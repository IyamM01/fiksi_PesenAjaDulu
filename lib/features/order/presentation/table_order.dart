import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fiksi/features/order/presentation/providers/order_provider.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/providers/restaurant_provider.dart';
import 'package:flutter_fiksi/features/restaurant/domain/entities/table.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';
import 'package:intl/intl.dart';

class TableOrder extends ConsumerStatefulWidget {
  const TableOrder({super.key});

  @override
  ConsumerState<TableOrder> createState() => _TableOrderState();
}

class _TableOrderState extends ConsumerState<TableOrder> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedTable;

  // Static table list (connected to API data for availability)
  final List<String> staticTables = [
    'Meja 1',
    'Meja 2',
    'Meja 3',
    'Meja 4',
    'Meja 5',
    'Meja 6',
    'Meja 7',
    'Meja 8',
    'Meja 9',
    'Meja 10',
  ];

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orderItems = ref.watch(orderItemsProvider);
    final orderTotal = ref.watch(orderTotalProvider);

    // Get restaurant tables if available
    final restaurantId = orderState.restaurantId;
    final restaurantAsync =
        restaurantId != null
            ? ref.watch(restaurantByIdProvider(restaurantId))
            : null;

    // Get available tables from restaurant data
    final availableTables =
        restaurantAsync?.when(
          loading: () => staticTables, // Show all tables while loading
          error: (_, __) => staticTables, // Show all tables on error
          data: (restaurant) {
            final apiTables = restaurant.tables ?? [];
            return staticTables.where((tableName) {
              // Extract number from "Meja X" format
              final match = RegExp(r'Meja (\d+)').firstMatch(tableName);
              if (match != null) {
                final tableNumber = int.parse(match.group(1)!);
                // Check if this table is available in API
                final apiTable = apiTables.firstWhere(
                  (table) => table.id == tableNumber,
                  orElse:
                      () =>
                          RestaurantTable(id: tableNumber, status: 'available'),
                );
                // Only show available tables (which are now colored black)
                return apiTable.isAvailable;
              }
              return true;
            }).toList();
          },
        ) ??
        staticTables;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Pemesanan Meja',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE9ECEF)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ringkasan Pesanan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212529),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${orderItems.length} item pesanan',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6C757D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${orderTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Table status legend
            const TableStatusLegend(),
            const SizedBox(height: 20),

            // Table Floor Map - Dynamic with bigger, better design
            Container(
              width: double.infinity,
              height: 350, // Fixed height for better layout
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE9ECEF)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    restaurantAsync?.when(
                      data:
                          (restaurant) => TableFloorMap(
                            tables: restaurant.tables ?? [],
                            selectedTable:
                                null, // Keep selection in dropdown only
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
                          () => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFFF6B35),
                              strokeWidth: 3,
                            ),
                          ),
                      error:
                          (error, stack) => const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Color(0xFFADB5BD),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Error loading table data',
                                  style: TextStyle(
                                    color: Color(0xFFADB5BD),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ) ??
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.table_restaurant,
                            size: 80,
                            color: Color(0xFFADB5BD),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No restaurant selected',
                            style: TextStyle(
                              color: Color(0xFFADB5BD),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Booking Details Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE9ECEF)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212529),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date Selection
                    _buildDatePicker(),
                    const SizedBox(height: 20),

                    // Time Selection
                    _buildTimePicker(),
                    const SizedBox(height: 20),

                    // Table Selection
                    _buildTableDropdown(availableTables),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canContinue() ? () => _proceedToPayment() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _canContinue()
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFFADB5BD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: _canContinue() ? 4 : 0,
                  shadowColor: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                ),
                child: const Text(
                  'Review Pesanan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilh Tanggal',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFFFF6B35),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                      surfaceContainerHighest: Color(0xFFF8F9FA),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    selectedDate != null
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFFE9ECEF),
                width: 2,
              ),
              boxShadow:
                  selectedDate != null
                      ? [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        selectedDate != null
                            ? const Color(0xFFFF6B35)
                            : const Color(0xFF6C757D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Reservasi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              selectedDate != null
                                  ? const Color(0xFF6C757D)
                                  : const Color(0xFFADB5BD),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedDate != null
                            ? DateFormat(
                              'EEEE, dd MMMM yyyy',
                            ).format(selectedDate!)
                            : 'Pilih tanggal reservasi Anda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              selectedDate != null
                                  ? const Color(0xFF212529)
                                  : const Color(0xFFADB5BD),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color:
                      selectedDate != null
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF6C757D),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Waktu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFFFF6B35),
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black,
                      surfaceContainerHighest: Color(0xFFF8F9FA),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                selectedTime = picked;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    selectedTime != null
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFFE9ECEF),
                width: 2,
              ),
              boxShadow:
                  selectedTime != null
                      ? [
                        BoxShadow(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        selectedTime != null
                            ? const Color(0xFFFF6B35)
                            : const Color(0xFF6C757D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Waktu Reservasi',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              selectedTime != null
                                  ? const Color(0xFF6C757D)
                                  : const Color(0xFFADB5BD),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedTime != null
                            ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                            : 'Pilih waktu reservasi Anda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              selectedTime != null
                                  ? const Color(0xFF212529)
                                  : const Color(0xFFADB5BD),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color:
                      selectedTime != null
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF6C757D),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableDropdown(List<String> availableTables) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Meja',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  selectedTable != null
                      ? const Color(0xFFFF6B35)
                      : const Color(0xFFE9ECEF),
              width: 2,
            ),
            boxShadow:
                selectedTable != null
                    ? [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedTable,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      selectedTable != null
                          ? const Color(0xFFFF6B35)
                          : const Color(0xFF6C757D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.table_restaurant,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            hint: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nomor Meja',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFADB5BD),
                  ),
                ),
              ],
            ),
            items:
                availableTables.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF212529),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (value) => setState(() => selectedTable = value),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6C757D),
              size: 24,
            ),
            style: const TextStyle(fontSize: 16, color: Color(0xFF212529)),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }

  bool _canContinue() {
    return selectedDate != null &&
        selectedTime != null &&
        selectedTable != null;
  }

  void _proceedToPayment() {
    if (!_canContinue()) return;

    // Combine date and time into a single DateTime
    final reservationDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Extract table number from "Meja X" format
    final match = RegExp(r'Meja (\d+)').firstMatch(selectedTable!);
    if (match != null) {
      final tableNumber = int.parse(match.group(1)!);

      // Update order with table selection and reservation details
      ref
          .read(orderProvider.notifier)
          .updateTableSelection(tableNumber.toString(), reservationDateTime);

      // Navigate to payment summary
      context.push('/payment_summary');
    }
  }
}
