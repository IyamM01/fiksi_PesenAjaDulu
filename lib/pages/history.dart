import 'package:flutter/material.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          HistoryCard(
            restaurantName: 'Mang Engking',
            imageUrl: 'assets/image/menu.png',
            date: '10-10-2025',
            price: 'Rp100000',
            tableNumber: '10',
            status: false,
            onTap: () {},
          ),

          HistoryCard(
            restaurantName: 'Mang Engking',
            imageUrl: 'assets/image/menu.png',
            date: '10-10-2025',
            price: 'Rp100000',
            tableNumber: '10',
            status: true,
            onTap: () {},
          ),

          HistoryCard(
            restaurantName: 'Mang Engking',
            imageUrl: 'assets/image/menu.png',
            date: '10-10-2025',
            price: 'Rp100000',
            tableNumber: '10',
            status: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
