import 'package:flutter/material.dart';
import 'package:flutter_fiksi/pages/history.dart';
import 'package:flutter_fiksi/pages/menu.dart';
import 'package:flutter_fiksi/widgets/widgets.dart';
import 'package:flutter_fiksi/pages/profile.dart';

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

  final List<Widget> pages = const [
    HomeWidget(),
    Menu(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFE7F00),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.restaurant, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color(0xFFFE7F00),
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => pageIndex = 0),
                      icon: Icon(
                        Icons.home,
                        size: 33,
                        color:
                            pageIndex == 0
                                ? const Color(0xFF4E2A00)
                                : const Color(0xFF999999),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => pageIndex = 1),
                      icon: Icon(
                        Icons.menu_book,
                        size: 33,
                        color:
                            pageIndex == 1
                                ? const Color(0xFF4E2A00)
                                : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 60),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => setState(() => pageIndex = 2),
                      icon: Icon(
                        Icons.history_edu_outlined,
                        size: 33,
                        color:
                            pageIndex == 2
                                ? const Color(0xFF4E2A00)
                                : const Color(0xFF999999),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => pageIndex = 3),
                      icon: Icon(
                        Icons.person,
                        size: 33,
                        color:
                            pageIndex == 3
                                ? const Color(0xFF4E2A00)
                                : const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        'assets/icon/profile.png',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promo',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3F2200),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280.0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
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
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            MenuCard(
              imageUrl: 'assets/image/menu.png',
              title: 'Menu 1',
              category: 'main course',
              nameresto: 'Mang Engking',
              price: 'Rp10.000',
            ),
            MenuCard(
              imageUrl: 'assets/image/menu.png',
              title: 'Menu 2',
              category: 'dessert',
              nameresto: 'Mang Engking',
              price: 'Rp12.000',
            ),
            MenuCard(
              imageUrl: 'assets/image/menu.png',
              nameresto: 'Mang Engking',
              title: 'Menu 3',
              category: 'main course',
              price: 'Rp15.000',
            ),
            MenuCard(
              imageUrl: 'assets/image/menu.png',
              nameresto: 'Mang Engking',
              title: 'Menu 4',
              category: 'beverage',
              price: 'Rp8.000',
            ),
          ],
        ),
      ],
    );
  }
}
