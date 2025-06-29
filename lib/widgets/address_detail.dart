import 'package:flutter/material.dart';

class AddressDetail extends StatelessWidget {
  final String title;
  final String subtitle;

  const AddressDetail({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.orange),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
