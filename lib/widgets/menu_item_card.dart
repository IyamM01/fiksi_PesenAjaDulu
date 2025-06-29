import 'package:flutter/material.dart';

class MenuItemCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String price;
  final int quantity;

  const MenuItemCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Rp$price', style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove), onPressed: () {}),
              Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
              IconButton(icon: const Icon(Icons.add), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
