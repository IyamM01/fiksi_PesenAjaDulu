import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String price;

  const MenuCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Image.asset(imageUrl, fit: BoxFit.cover, width: 100, height: 100),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Color(0xFF4E2A00), fontWeight: FontWeight.w600)),
            Text(
              category,
              style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 14, color: Color(0xFFBF360C), fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
