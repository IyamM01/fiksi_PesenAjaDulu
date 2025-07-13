import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'providers/order_provider.dart';

class PaymentSummaryPage extends ConsumerWidget {
  const PaymentSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final orderItems = ref.watch(orderItemsProvider);
    final orderSubtotal = ref.watch(orderSubtotalProvider);
    final orderTax = ref.watch(orderTaxProvider);
    final orderTotal = ref.watch(orderTotalProvider);

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
          'Ringkasan Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reservation Details Card
                  _buildReservationDetailsCard(orderState),
                  const SizedBox(height: 20),

                  // Order Items Card
                  _buildOrderItemsCard(orderItems),
                  const SizedBox(height: 20),

                  // Payment Method Card
                  _buildPaymentMethodCard(),
                  const SizedBox(height: 20),

                  // Price Breakdown Card
                  _buildPriceBreakdownCard(orderSubtotal, orderTax, orderTotal),
                ],
              ),
            ),
          ),

          // Bottom Payment Button
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Payment Split Information
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFB3D9FF)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF007BFF),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Sistem Pembayaran',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF007BFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bayar Online (50%):',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF007BFF),
                            ),
                          ),
                          Text(
                            'Rp ${(orderTotal / 2).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF007BFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Bayar di Resto (50%):',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF007BFF),
                            ),
                          ),
                          Text(
                            'Rp ${(orderTotal / 2).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF007BFF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Total Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212529),
                      ),
                    ),
                    Text(
                      'Rp ${(orderTotal / 2).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pay Now Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _processPayment(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      shadowColor: const Color(
                        0xFFFF6B35,
                      ).withValues(alpha: 0.3),
                    ),
                    child: Text(
                      'Bayar Rp ${(orderTotal / 2).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationDetailsCard(OrderState orderState) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.table_restaurant,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Detail Reservasi Meja',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Reservation Details
            _buildDetailRow(
              icon: Icons.calendar_today,
              label: 'Tanggal',
              value:
                  orderState.reservationTime != null
                      ? DateFormat(
                        'EEEE, dd MMMM yyyy',
                      ).format(orderState.reservationTime!)
                      : 'Belum dipilih',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Waktu',
              value:
                  orderState.reservationTime != null
                      ? DateFormat('HH:mm').format(orderState.reservationTime!)
                      : 'Belum dipilih',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.table_restaurant,
              label: 'Meja',
              value:
                  orderState.selectedTableId != null
                      ? 'Meja ${orderState.selectedTableId}'
                      : 'Belum dipilih',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.restaurant,
              label: 'Restaurant',
              value: orderState.restaurantName ?? 'Mang Engking',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsCard(List<dynamic> orderItems) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                  child: Text(
                    'Pesanan Anda (${orderItems.length} item)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Order Items List
            if (orderItems.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Tidak ada item pesanan',
                    style: TextStyle(color: Color(0xFF6C757D), fontSize: 16),
                  ),
                ),
              )
            else
              ...orderItems.map((item) => _buildOrderItemRow(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Payment Method Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFF6B35), width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Midtrans Payment Gateway',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF212529),
                          ),
                        ),
                        Text(
                          'Credit Card, Bank Transfer, E-Wallet',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownCard(double subtotal, double tax, double total) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE9ECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Rincian Harga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Price Breakdown
            _buildPriceRow('Subtotal', subtotal),
            const SizedBox(height: 12),
            _buildPriceRow('Pajak & Biaya Layanan', tax),
            const Divider(height: 24, color: Color(0xFFE9ECEF)),
            _buildPriceRow('Total', total, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6C757D)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6C757D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212529),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemRow(dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF8F9FA),
              image:
                  item.menuItemImage != null && item.menuItemImage.isNotEmpty
                      ? DecorationImage(
                        image: NetworkImage(item.menuItemImage),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                item.menuItemImage == null || item.menuItemImage.isEmpty
                    ? const Icon(
                      Icons.restaurant_menu,
                      color: Color(0xFFADB5BD),
                      size: 20,
                    )
                    : null,
          ),
          const SizedBox(width: 12),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItemName ?? 'Unknown Item',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rp ${item.price?.toStringAsFixed(0) ?? '0'} x ${item.quantity ?? 1}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C757D),
                  ),
                ),
                if (item.notes != null && item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Catatan: ${item.notes}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6C757D),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Item Total
          Text(
            'Rp ${item.totalPrice?.toStringAsFixed(0) ?? '0'}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? const Color(0xFF212529) : const Color(0xFF6C757D),
          ),
        ),
        Text(
          'Rp ${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? const Color(0xFFFF6B35) : const Color(0xFF212529),
          ),
        ),
      ],
    );
  }

  Future<void> _processPayment(BuildContext context, WidgetRef ref) async {
    final orderTotal = ref.read(orderTotalProvider);

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),
      );

      // Call API to create order and get order details
      final orderResult = await ref.read(orderProvider.notifier).createOrder();

      // Hide loading
      if (context.mounted) {
        Navigator.of(context).pop();

        if (orderResult != null) {
          // Navigate to payment WebView with real order data including amounts
          context.push(
            '/payment-webview',
            extra: {
              ...orderResult,
              // Ensure we have all the payment amounts for the success page
              'onlineAmount':
                  orderResult['onlineAmount'] ??
                  (orderTotal / 2).toStringAsFixed(0),
              'restaurantAmount':
                  orderResult['restaurantAmount'] ??
                  (orderTotal / 2).toStringAsFixed(0),
              'totalAmount':
                  orderResult['totalAmount'] ?? orderTotal.toStringAsFixed(0),
            },
          );
        } else {
          // Show error if order creation failed
          final errorMessage =
              ref.read(orderProvider).errorMessage ?? 'Unknown error occurred';
          _showErrorDialog(context, errorMessage);
        }
      }
    } catch (error) {
      // Hide loading and show error
      if (context.mounted) {
        Navigator.of(context).pop();
        _showErrorDialog(context, 'Failed to process payment: $error');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Payment Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
