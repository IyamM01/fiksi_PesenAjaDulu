import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final String qty;
  final String name;
  final String price;
  final bool isBold;
  final Color? color;

  const OrderItem({
    super.key,
    required this.qty,
    required this.name,
    required this.price,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color ?? Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('$qty $name', style: style), Text(price, style: style)],
      ),
    );
  }
}
