import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fiksi/features/history/presentation/history.dart';
import 'package:flutter_fiksi/features/menu/presentation/menu.dart';
import 'package:flutter_fiksi/features/menu/presentation/providers/menu_provider.dart';
import 'package:flutter_fiksi/features/profile/presentation/profile.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/resto.dart';
import 'package:flutter_fiksi/features/home/presentation/home.dart';

class MainNavigationWrapper extends ConsumerStatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  ConsumerState<MainNavigationWrapper> createState() =>
      _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends ConsumerState<MainNavigationWrapper> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Load menu items when app loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuProvider.notifier).loadMenuItems();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          HomePage(),
          Menu(),
          HistoryPage(),
          ProfilePage(),
          Resto(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(4),
        backgroundColor: const Color(0xFFFE7F00),
        elevation: 6,
        shape: const CircleBorder(),
        child: Image.asset('assets/icon/meja.png', width: 32, height: 32),
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
                      onPressed: () => _onItemTapped(0),
                      icon: Icon(
                        Icons.home,
                        size: 33,
                        color:
                            _selectedIndex == 0
                                ? const Color(0xFF4E2A00)
                                : const Color(0xFF999999),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _onItemTapped(1),
                      icon: Icon(
                        Icons.menu_book,
                        size: 33,
                        color:
                            _selectedIndex == 1
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
                      onPressed: () => _onItemTapped(2),
                      icon: Icon(
                        Icons.history,
                        size: 33,
                        color:
                            _selectedIndex == 2
                                ? const Color(0xFF4E2A00)
                                : const Color(0xFF999999),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _onItemTapped(3),
                      icon: Icon(
                        Icons.person,
                        size: 33,
                        color:
                            _selectedIndex == 3
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
    );
  }
}
