import 'package:flutter/material.dart';

class SeatTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const SeatTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(text),
    );
  }
}
