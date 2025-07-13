import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'providers/order_provider.dart';

class OrderSuccessPage extends ConsumerStatefulWidget {
  final String orderId;
  final String orderNumber;
  final String onlineAmount;
  final String restaurantAmount;
  final String totalAmount;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.onlineAmount,
    required this.restaurantAmount,
    required this.totalAmount,
  });

  @override
  ConsumerState<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends ConsumerState<OrderSuccessPage> {
  @override
  void initState() {
    super.initState();
    // Complete the payment process, add to order history, and clear the cart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Create order details map from the passed parameters
      final orderDetails = {
        'orderId': widget.orderId,
        'orderNumber': widget.orderNumber,
        'onlineAmount': widget.onlineAmount,
        'restaurantAmount': widget.restaurantAmount,
        'totalAmount': widget.totalAmount,
      };

      // Use the enhanced method that adds to order history
      ref
          .read(orderProvider.notifier)
          .completePaymentWithOrderDetails(orderDetails, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Success Animation/Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Success Title
                    const Text(
                      'Pembayaran Berhasil!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF22C55E),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Pesanan Anda telah dikonfirmasi dan sedang diproses',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // Order Details Card
                    _buildOrderDetailsCard(),

                    const SizedBox(height: 20),

                    // Payment Summary Card
                    _buildPaymentSummaryCard(),

                    const SizedBox(height: 20),

                    // Reservation Details Card
                    _buildReservationDetailsCard(orderState),

                    const SizedBox(height: 20),

                    // Next Steps Card
                    _buildNextStepsCard(),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            _buildBottomActions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
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
                    color: const Color(0xFF22C55E),
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
                    'Detail Pesanan',
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

            _buildDetailRow(
              icon: Icons.tag,
              label: 'Nomor Pesanan',
              value: widget.orderNumber,
              isHighlighted: true,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Waktu Pemesanan',
              value: DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.restaurant,
              label: 'Status',
              value: 'Dikonfirmasi',
              valueColor: const Color(0xFF22C55E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard() {
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
                    color: const Color(0xFF22C55E),
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
                    'Ringkasan Pembayaran',
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

            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF22C55E),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Dibayar Online:',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
                ),
                const Spacer(),
                Text(
                  'Rp ${widget.onlineAmount}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF22C55E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.schedule, color: Color(0xFFF59E0B), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Bayar di Restoran:',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
                ),
                const Spacer(),
                Text(
                  'Rp ${widget.restaurantAmount}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: Color(0xFFE9ECEF)),

            Row(
              children: [
                const Text(
                  'Total Pesanan:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
                const Spacer(),
                Text(
                  'Rp ${widget.totalAmount}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                    color: const Color(0xFF22C55E),
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
                    'Detail Reservasi',
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

  Widget _buildNextStepsCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFFF0F7FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFB3D9FF)),
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
                    color: const Color(0xFF007BFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Langkah Selanjutnya',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF007BFF),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildStepItem(
              number: '1',
              title: 'Datang ke Restoran',
              description:
                  'Tunjukkan nomor pesanan (${widget.orderNumber}) kepada staff restoran',
            ),
            const SizedBox(height: 16),
            _buildStepItem(
              number: '2',
              title: 'Bayar Sisa Pembayaran',
              description:
                  'Lakukan pembayaran sisa Rp ${widget.restaurantAmount} di kasir',
            ),
            const SizedBox(height: 16),
            _buildStepItem(
              number: '3',
              title: 'Nikmati Makanan',
              description:
                  'Duduk di meja yang telah direservasi dan nikmati makanan Anda',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isHighlighted = false,
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
        Container(
          padding:
              isHighlighted
                  ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                  : null,
          decoration:
              isHighlighted
                  ? BoxDecoration(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  )
                  : null,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color:
                  valueColor ??
                  (isHighlighted
                      ? const Color(0xFFFF6B35)
                      : const Color(0xFF212529)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF007BFF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007BFF),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Color(0xFF007BFF)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref) {
    return Container(
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
          // Save Order Number Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () => _saveOrderToHistory(context, ref),
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('Simpan ke Riwayat'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF6B35),
                side: const BorderSide(color: Color(0xFFFF6B35)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Back to Home Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _goToHome(context, ref),
              icon: const Icon(Icons.home),
              label: const Text('Kembali ke Beranda'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: const Color(0xFFFF6B35).withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveOrderToHistory(BuildContext context, WidgetRef ref) {
    // TODO: Implement save to order history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pesanan telah disimpan ke riwayat'),
        backgroundColor: Color(0xFF22C55E),
      ),
    );
  }

  void _goToHome(BuildContext context, WidgetRef ref) {
    // Clear the current order state
    ref.read(orderProvider.notifier).clearCart();

    // Navigate to home and clear all previous routes
    context.go('/home');
  }
}
