import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String snapUrl;
  final String orderId;
  final String orderNumber;
  final String? onlineAmount;
  final String? restaurantAmount;
  final String? totalAmount;

  const PaymentWebViewPage({
    super.key,
    required this.snapUrl,
    required this.orderId,
    required this.orderNumber,
    this.onlineAmount,
    this.restaurantAmount,
    this.totalAmount,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });

                // Check if payment is completed or cancelled
                _handlePaymentRedirect(url);
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('WebView error: ${error.description}');
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.snapUrl));
  }

  void _handlePaymentRedirect(String url) {
    // Handle different payment result URLs
    if (url.contains('status_code=200') ||
        url.contains('transaction_status=settlement')) {
      // Payment successful
      _showSuccessDialog();
    } else if (url.contains('status_code=201') ||
        url.contains('transaction_status=pending')) {
      // Payment pending
      _showPendingDialog();
    } else if (url.contains('status_code=202') ||
        url.contains('transaction_status=cancel')) {
      // Payment cancelled
      _showCancelDialog();
    } else if (url.contains('status_code=407') ||
        url.contains('transaction_status=expire')) {
      // Payment expired
      _showExpiredDialog();
    }
  }

  void _showSuccessDialog() {
    // Navigate directly to order success page instead of showing dialog
    _navigateToOrderSuccess();
  }

  void _navigateToOrderSuccess() {
    context.go(
      '/order-success',
      extra: {
        'orderId': widget.orderId,
        'orderNumber': widget.orderNumber,
        'onlineAmount': widget.onlineAmount ?? '0',
        'restaurantAmount': widget.restaurantAmount ?? '0',
        'totalAmount': widget.totalAmount ?? '0',
      },
    );
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.hourglass_top, color: Colors.orange, size: 28),
                SizedBox(width: 12),
                Text('Pembayaran Pending'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nomor Pesanan: ${widget.orderNumber}'),
                const SizedBox(height: 8),
                const Text(
                  'Pembayaran Anda sedang diproses. Kami akan memberitahu Anda jika pembayaran sudah dikonfirmasi.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to order success page to show pending status
                  _navigateToOrderSuccess();
                },
                child: const Text('Lihat Detail Pesanan'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.cancel, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text('Pembayaran Dibatalkan'),
              ],
            ),
            content: const Text(
              'Pembayaran telah dibatalkan. Anda dapat mencoba lagi atau memilih metode pembayaran lain.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/payment_summary');
                },
                child: const Text('Coba Lagi'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
    );
  }

  void _showExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.timer_off, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text('Pembayaran Kedaluwarsa'),
              ],
            ),
            content: const Text(
              'Sesi pembayaran telah kedaluwarsa. Silakan lakukan pemesanan ulang.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            _showCancelConfirmation();
          },
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFFF6B35)),
                  SizedBox(height: 16),
                  Text(
                    'Memuat halaman pembayaran...',
                    style: TextStyle(fontSize: 16, color: Color(0xFF6C757D)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Batalkan Pembayaran?'),
            content: const Text(
              'Apakah Anda yakin ingin membatalkan proses pembayaran?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/payment_summary');
                },
                child: const Text('Ya, Batalkan'),
              ),
            ],
          ),
    );
  }
}
