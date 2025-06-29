import 'package:flutter/material.dart';

class RestoCard extends StatelessWidget {
  final String name;
  final String imageurl;

  const RestoCard({super.key, required this.name, required this.imageurl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/order_menu');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Image.asset(imageurl, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4E2C0B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
