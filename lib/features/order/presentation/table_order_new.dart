import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';
import 'package:flutter_fiksi/features/order/presentation/providers/order_provider.dart';
import 'package:flutter_fiksi/features/restaurant/domain/entities/table.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/providers/restaurant_provider.dart';

class TableOrder extends ConsumerStatefulWidget {
  const TableOrder({super.key});

  @override
  ConsumerState<TableOrder> createState() => _TableOrderState();
}

class _TableOrderState extends ConsumerState<TableOrder> {
  String? selectedDate;
  String? selectedTime;
  RestaurantTable? selectedTable;

  final List<String> dates = ['5 Juli 2025', '6 Juli 2025', '7 Juli 2025'];
  final List<String> times = ['10:00', '12:00', '14:00', '16:00'];

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orderItems = ref.watch(orderItemsProvider);
    final orderTotal = ref.watch(orderTotalProvider);
    final restaurantName = ref.watch(orderRestaurantProvider);
    final restaurantId = orderState.restaurantId;

    // Fetch restaurant details to get table data
    final restaurantAsyncValue =
        restaurantId != null
            ? ref.watch(restaurantByIdProvider(restaurantId))
            : null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Seat',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body:
          restaurantAsyncValue == null
              ? const Center(child: Text('No restaurant selected'))
              : restaurantAsyncValue.when(
                data:
                    (restaurant) => _buildTableSelection(
                      context,
                      restaurant,
                      orderItems,
                      orderTotal,
                      restaurantName,
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, stackTrace) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error loading restaurant data: $error'),
                          ElevatedButton(
                            onPressed: () {
                              if (restaurantId != null) {
                                ref.invalidate(
                                  restaurantByIdProvider(restaurantId),
                                );
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
              ),
    );
  }

  Widget _buildTableSelection(
    BuildContext context,
    restaurant,
    orderItems,
    orderTotal,
    restaurantName,
  ) {
    final tables = restaurant.tables ?? <RestaurantTable>[];
    final availableTables = restaurant.availableTables;

    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        children: [
          // Restaurant name header
          if (restaurantName != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.orange.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurantName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${orderItems.length} items - Rp${orderTotal.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Table status legend
          const TableStatusLegend(),

          const SizedBox(height: 16),

          // Table floor map with real data
          TableFloorMap(
            tables: tables,
            selectedTable: selectedTable,
            onTableSelected: (table) {
              setState(() {
                selectedTable = table;
              });
            },
          ),

          const SizedBox(height: 24),

          // Date selection
          Dropdown(
            hint: 'Pilih Tanggal',
            value: selectedDate,
            items: dates,
            onChanged: (val) => setState(() => selectedDate = val),
          ),

          const SizedBox(height: 16),

          // Time selection
          Dropdown(
            hint: 'Pilih Jam',
            value: selectedTime,
            items: times,
            onChanged: (val) => setState(() => selectedTime = val),
          ),

          const SizedBox(height: 16),

          // Table selection dropdown (showing available tables only)
          Dropdown(
            hint: 'Pilih Meja',
            value: selectedTable?.displayName,
            items: availableTables.map((table) => table.displayName).toList(),
            onChanged: (val) {
              final table = availableTables.firstWhere(
                (t) => t.displayName == val,
                orElse: () => availableTables.first,
              );
              setState(() => selectedTable = table);
            },
          ),

          const SizedBox(height: 16),

          // Selected table info
          if (selectedTable != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Selected: ${selectedTable!.displayName} (Capacity: ${selectedTable!.capacity} people)',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const Spacer(),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
                  selectedDate != null &&
                          selectedTime != null &&
                          selectedTable != null
                      ? () {
                        // Update order with table selection
                        ref
                            .read(orderProvider.notifier)
                            .updateTableSelection(
                              selectedTable!.id.toString(),
                              DateTime.now(), // You might want to parse selectedDate and selectedTime
                            );

                        // Navigate to payment
                        context.push('/payment');
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lanjutkan ke Pembayaran',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
