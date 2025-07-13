import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderVerificationPage extends ConsumerStatefulWidget {
  const OrderVerificationPage({super.key});

  @override
  ConsumerState<OrderVerificationPage> createState() =>
      _OrderVerificationPageState();
}

class _OrderVerificationPageState extends ConsumerState<OrderVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _orderNumberController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _orderNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Cek Status Pesanan',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Card(
                elevation: 0,
                color: const Color(0xFFF0F7FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFB3D9FF)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cara Cek Pesanan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF007BFF),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Masukkan email dan nomor pesanan Anda untuk melihat status pembayaran dan reservasi meja.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF007BFF),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Email Field
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Masukkan email Anda',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Order Number Field
              _buildTextField(
                controller: _orderNumberController,
                label: 'Nomor Pesanan',
                hint: 'Contoh: ORD-20250713-123456',
                icon: Icons.receipt_long,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor pesanan tidak boleh kosong';
                  }
                  if (!RegExp(r'^ORD-\d{8}-\d{6}$').hasMatch(value)) {
                    return 'Format nomor pesanan tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Check Order Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _checkOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                  ),
                  child:
                      _isLoading
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Memeriksa...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                          : const Text(
                            'Cek Status Pesanan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),

              // Help Text
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Tidak menemukan nomor pesanan?',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to help or contact page
                        _showHelpDialog();
                      },
                      child: const Text(
                        'Hubungi Customer Service',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212529),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _checkOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement API call to check order status
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Mock order data - replace with actual API response
        final orderData = {
          'orderNumber': _orderNumberController.text,
          'status':
              'confirmed', // 'pending', 'confirmed', 'cancelled', 'completed'
          'paymentStatus':
              'partial_paid', // 'pending', 'partial_paid', 'paid', 'failed'
          'reservationDate': '2025-07-15',
          'reservationTime': '19:00',
          'tableName': 'Meja 5',
          'restaurantName': 'Mang Engking',
          'total': 125000,
          'onlinePaid': 62500, // 50% paid online
          'restaurantAmount': 62500, // 50% to pay at restaurant
          'createdAt': '2025-07-13 14:30',
        };

        _showOrderStatusDialog(orderData);
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Gagal memeriksa status pesanan: $error');
      }
    }
  }

  void _showOrderStatusDialog(Map<String, dynamic> orderData) {
    final status = orderData['status'] as String;
    final paymentStatus = orderData['paymentStatus'] as String;

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_top;
        statusText = 'Menunggu Konfirmasi';
        break;
      case 'confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Dikonfirmasi';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Dibatalkan';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        statusText = 'Selesai';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = 'Status Tidak Diketahui';
    }

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Pesanan ${orderData['orderNumber']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212529),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          'Restoran',
                          orderData['restaurantName'],
                        ),
                        _buildDetailRow('Meja', orderData['tableName']),
                        _buildDetailRow(
                          'Tanggal',
                          orderData['reservationDate'],
                        ),
                        _buildDetailRow('Waktu', orderData['reservationTime']),
                        _buildDetailRow(
                          'Total',
                          'Rp ${orderData['total'].toString()}',
                        ),
                        _buildDetailRow(
                          'Dibayar Online',
                          'Rp ${orderData['onlinePaid'].toString()}',
                        ),
                        _buildDetailRow(
                          'Sisa Bayar di Resto',
                          'Rp ${orderData['restaurantAmount'].toString()}',
                        ),
                        _buildDetailRow(
                          'Status Pembayaran',
                          paymentStatus == 'partial_paid'
                              ? 'Sebagian Lunas'
                              : paymentStatus == 'paid'
                              ? 'Lunas'
                              : paymentStatus == 'pending'
                              ? 'Menunggu'
                              : 'Gagal',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6C757D),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // TODO: Navigate to order details page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6C757D)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212529),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
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

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Bantuan'),
            content: const Text(
              'Jika Anda tidak dapat menemukan nomor pesanan, silakan hubungi customer service kami:\n\n'
              'WhatsApp: +62 123-456-7890\n'
              'Email: support@pesanajadulu.com\n\n'
              'Sertakan email yang digunakan saat pemesanan untuk mempercepat proses bantuan.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }
}
