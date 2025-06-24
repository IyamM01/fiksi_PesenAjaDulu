import 'package:flutter/material.dart';
import 'package:flutter_fiksi/pages/menu.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class PromoCard extends StatelessWidget {
  final String imageUrl;

  const PromoCard({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Image.asset(imageUrl, fit: BoxFit.cover, width: 280)],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  final List<Widget> pages = const [HomeWidget(), Menu()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4E2A00),
        unselectedItemColor: const Color(0xFF999999),
        backgroundColor: Colors.yellow,
        currentIndex: pageIndex,
        onTap: (index) {
          // Handle navigation logic here
          setState(() {
            pageIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hallo, Username',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4E2A00),
                        ),
                      ),
                      Text(
                        '@username',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD5A87B),
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.orange,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icon/profile.png', // Ganti dengan path gambar profil yang sesuai
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              pages[pageIndex],
            ],
          ),
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Promo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3F2200),
              ),
            ),
            SizedBox(height: 16),
            // Promo Card
            SizedBox(
              height: 280.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  PromoCard(imageUrl: 'assets/image/promo.png'),
                  PromoCard(imageUrl: 'assets/image/promo.png'),
                  PromoCard(imageUrl: 'assets/image/promo.png'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Menu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF754414),
              ),
            ),

            const SizedBox(height: 16),

            // Menu Cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                MenuCard(
                  imageUrl: 'assets/image/menu.png',
                  title: 'Menu 1',
                  category: 'main course',
                  price: 'Rp10.000',
                ),
                MenuCard(
                  imageUrl: 'assets/image/menu.png',
                  title: 'Menu 2',
                  category: 'dessert',
                  price: 'Rp12.000',
                ),
                MenuCard(
                  imageUrl: 'assets/image/menu.png',
                  title: 'Menu 3',
                  category: 'main course',
                  price: 'Rp15.000',
                ),
                MenuCard(
                  imageUrl: 'assets/image/menu.png',
                  title: 'Menu 4',
                  category: 'beverage',
                  price: 'Rp8.000',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
