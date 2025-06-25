import 'package:flutter/material.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String selectedCategory = 'All';

  // Data menu contoh
  final List<Map<String, String>> menuItems = [
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Nasi Goreng',
      'category': 'Main Course',
      'nameresto': 'Mang Engking',
      'price': 'Rp25.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Ayam Bakar',
      'category': 'Main Course',
      'nameresto': 'Mang Engking',
      'price': 'Rp30.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Es Teh',
      'category': 'Drinks',
      'nameresto': 'Mang Engking',
      'price': 'Rp8.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Es Jeruk',
      'category': 'Drinks',
      'nameresto': 'Mang Engking',
      'price': 'Rp10.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Pudding',
      'category': 'Dessert',
      'nameresto': 'Mang Engking',
      'price': 'Rp15.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Kentang Goreng',
      'category': 'Snacks',
      'nameresto': 'Mang Engking',
      'price': 'Rp12.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Sate Ayam',
      'category': 'Main Course',
      'nameresto': 'Mang Engking',
      'price': 'Rp28.000',
    },
    {
      'imageUrl': 'assets/image/menu.png',
      'title': 'Jus Alpukat',
      'category': 'Drinks',
      'nameresto': 'Mang Engking',
      'price': 'Rp18.000',
    },
  ];

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // filter category
    final filteredMenu =
        selectedCategory == 'All'
            ? menuItems
            : menuItems
                .where((item) => item['category'] == selectedCategory)
                .toList();

    return Container(
      child: Column(
        children: [
          // search bar
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

          // navmenu category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: Column(
              children: [
                NavCategory(
                  selectedCategory: selectedCategory,
                  onCategorySelected: onCategorySelected,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Nampilin menu
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                filteredMenu.map((menu) {
                  return MenuCard(
                    imageUrl: menu['imageUrl']!,
                    title: menu['title']!,
                    category: menu['category']!,
                    nameresto: menu['nameresto']!,
                    price: menu['price']!,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
