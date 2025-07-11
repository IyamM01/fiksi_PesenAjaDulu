import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final String method;
  final String total;
  final String dueTime;

  const PaymentCard({
    super.key,
    required this.method,
    required this.total,
    required this.dueTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Metode Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Image.asset(
                'assets/image/qris.png',
                width: 32,
                height: 32,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(method),
            ],
          ),
          const Divider(height: 32),
          Text(
            "Total Pembayaran",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            total,
            style: const TextStyle(fontSize: 20, color: Colors.orange),
          ),
          const SizedBox(height: 16),
          Text(
            "Bayar sebelum $dueTime",
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
