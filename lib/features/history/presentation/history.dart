import 'package:flutter/material.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';

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
            orderId: '11111',
            date: '10-10-2025',
            price: 'Rp100000',
            tableNumber: '10',
            status: 'pending',
            onTap: () {},
          ),

          HistoryCard(
            restaurantName: 'Mang Engking',
            imageUrl: 'assets/image/menu.png',
            orderId: '22222',
            date: '10-10-2025',
            price: 'Rp100000',
            tableNumber: '10',
            status: 'completed',
            onTap: () {},
          ),

          HistoryCard(
            restaurantName: 'Mang Engking',
            imageUrl: 'assets/image/menu.png',
            orderId: '33333',
            date: '10-10-2025',
            price: 'Rp100000',
            tableNumber: '10',
            status: 'completed',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
