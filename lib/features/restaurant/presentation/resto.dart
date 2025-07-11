import 'package:flutter/material.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';

class Resto extends StatefulWidget {
  const Resto({super.key});

  @override
  State<Resto> createState() => _RestoState();
}

class _RestoState extends State<Resto> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFCECDC),
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            height: 47,
            child: Align(
              alignment: Alignment.centerRight,
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.search, color: const Color(0xFF504F5E)),
                  ),
                  hintText: 'Search...',
                  fillColor: const Color(0xFF504F5E),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          RestoCard(
            name: 'Mang Engking',
            imageurl: 'assets/image/mang_engking.png',
          ),
        ],
      ),
    );
  }
}
