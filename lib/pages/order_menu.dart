import 'package:flutter/material.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';

class OrderMenuPage extends StatefulWidget {
  const OrderMenuPage({super.key});

  @override
  State<OrderMenuPage> createState() => _OrderMenuPageState();
}

class _OrderMenuPageState extends State<OrderMenuPage> {
  String selectedCategory = 'All';
  final List<Map<String, dynamic>> menu = [
    {
      'image': 'assets/image/menu.png',
      'title': 'Nasi Goreng',
      'category': 'Main Course',
      'nameresto': 'Mang Engking',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'price': 'Rp25.000',
      'quantity': 1,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Ayam Bakar',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Main Course',
      'nameresto': 'Mang Engking',
      'price': 'Rp30.000',
      'quantity': 5,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Es Teh',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Drinks',
      'nameresto': 'Mang Engking',
      'price': 'Rp8.000',
      'quantity': 3,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Es Jeruk',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Drinks',
      'nameresto': 'Mang Engking',
      'price': 'Rp10.000',
      'quantity': 9,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Pudding',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Dessert',
      'nameresto': 'Mang Engking',
      'price': 'Rp15.000',
      'quantity': 1,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Kentang Goreng',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Snacks',
      'nameresto': 'Mang Engking',
      'price': 'Rp12.000',
      'quantity': 1,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Sate Ayam',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Main Course',
      'nameresto': 'Mang Engking',
      'price': 'Rp28.000',
      'quantity': 1,
    },
    {
      'image': 'assets/image/menu.png',
      'title': 'Jus Alpukat',
      'description':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      'category': 'Drinks',
      'nameresto': 'Mang Engking',
      'price': 'Rp18.000',
      'quantity': 1,
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
    final filterMenu =
        selectedCategory == 'All'
            ? menu
            : menu
                .where((item) => item['category'] == selectedCategory)
                .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xFFFE7F00)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
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

            Expanded(
              child: ListView.builder(
                itemCount: filterMenu.length,
                itemBuilder: (context, index) {
                  final item = filterMenu[index];
                  return GestureDetector(
                    onTap:
                        () => MenuDescriptionPopup.show(
                          context: context,
                          title: item['title']!,
                          nameresto: item['nameresto']!,
                          description: item['description']!,
                          imageUrl: item['image'],
                        ),
                    child: MenuItemCard(
                      imageUrl: item['image'],
                      category: item['category'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity'],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24), // Tambahkan jarak sebelum tombol

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/table_order');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 55), // Tambahkan jarak bawah
          ],
        ),
      ),
    );
  }
}
