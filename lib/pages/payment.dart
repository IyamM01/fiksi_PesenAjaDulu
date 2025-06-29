import 'package:flutter/material.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const PaymentCard(
              method: "QRIS",
              total: "Rp239.100",
              dueTime: "16.30 WIB",
            ),
            const SizedBox(height: 24),
            // Gambar QR Code placeholder
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(
                'assets/image/qris.png', // Ganti dengan QRIS kamu
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Silakan scan QR di atas menggunakan aplikasi E-Wallet Anda (OVO, DANA, ShopeePay, dll)",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/payment_done');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Saya Sudah Bayar"),
              ),
            ),
          const SizedBox(height: 36,)
          ],
        ),
      ),
    );
  }
}
