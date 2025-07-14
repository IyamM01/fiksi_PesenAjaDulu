import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';
import 'package:flutter_fiksi/features/order/presentation/providers/order_provider.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/providers/restaurant_provider.dart';

class TableOrder extends ConsumerStatefulWidget {
  const TableOrder({super.key});

  @override
  ConsumerState<TableOrder> createState() => _TableOrderState();
}

class _TableOrderState extends ConsumerState<TableOrder> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedTable;

  // Static table list (same as before, but now connected to API data)
  final List<String> staticTables = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
    'Table 6',
    'Table 7',
    'Table 8',
    'Table 9',
    'Table 10',
  ];

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orderItems = ref.watch(orderItemsProvider);
    final orderTotal = ref.watch(orderTotalProvider);
    final restaurantName = ref.watch(orderRestaurantProvider);
    final restaurantId = orderState.restaurantId;

    // Fetch restaurant details to get table data for colors/status
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
      body: Padding(
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

            // Static table floor map connected to API data
            restaurantAsyncValue?.when(
                  data:
                      (restaurant) => TableFloorMap(
                        tables: restaurant.tables ?? [],
                        selectedTable: null, // Keep selection in dropdown only
                        onTableSelected: (table) {
                          // Map API table ID to static table name
                          final tableNumber = table.id ?? 1;
                          if (tableNumber <= staticTables.length) {
                            setState(() {
                              selectedTable = staticTables[tableNumber - 1];
                            });
                          }
                        },
                      ),
                  loading:
                      () => const SizedBox(
                        width: 300,
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  error:
                      (error, stack) => Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text('Error loading table data'),
                        ),
                      ),
                ) ??
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('No restaurant selected')),
                ),

            const SizedBox(height: 24),

            // Date selection
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Pilih Tanggal',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            selectedDate != null
                                ? Colors.black
                                : Colors.grey.shade600,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Time selection
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime != null
                          ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                          : 'Pilih Jam',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            selectedTime != null
                                ? Colors.black
                                : Colors.grey.shade600,
                      ),
                    ),
                    Icon(Icons.access_time, color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Static table selection dropdown that shows availability from API
            Dropdown(
              hint: 'Pilih Meja',
              value: selectedTable,
              items: _getAvailableStaticTables(restaurantAsyncValue),
              onChanged: (val) => setState(() => selectedTable = val),
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
                        'Selected: $selectedTable',
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
                          final tableId = _getTableIdFromName(selectedTable!);
                          ref
                              .read(orderProvider.notifier)
                              .updateTableSelection(tableId, selectedDate!);

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
      ),
    );
  }

  // Get available static tables based on API data
  List<String> _getAvailableStaticTables(restaurantAsyncValue) {
    if (restaurantAsyncValue == null) return staticTables;

    return restaurantAsyncValue.when(
      data: (restaurant) {
        final apiTables = restaurant.tables ?? [];
        final availableStaticTables = <String>[];

        for (int i = 0; i < staticTables.length; i++) {
          final tableNumber = i + 1;
          final apiTable = apiTables.firstWhere(
            (table) => table.id == tableNumber,
            orElse: () => null,
          );

          // Include table if it's available in API or if no API data for this table
          if (apiTable == null || apiTable.isAvailable) {
            availableStaticTables.add(staticTables[i]);
          }
        }

        return availableStaticTables;
      },
      loading: () => staticTables,
      error: (error, stack) => staticTables,
    );
  }

  // Date picker method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Time picker method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Convert static table name to table ID
  String _getTableIdFromName(String tableName) {
    final index = staticTables.indexOf(tableName);
    return (index + 1).toString(); // Table 1 = ID 1, Table 2 = ID 2, etc.
  }
}
