import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFCECDC),
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            height: 47,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.search),
            ),
          )
        ],
      ),
    );
  }
}
