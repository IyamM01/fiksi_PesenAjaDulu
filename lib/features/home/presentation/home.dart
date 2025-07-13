import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fiksi/features/menu/presentation/providers/menu_provider.dart';
import 'package:flutter_fiksi/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';

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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(currentUserProvider);
                  final isLoggedIn = ref.watch(isAuthenticatedProvider);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null && user.name.isNotEmpty
                                ? 'Hallo, ${user.name}'
                                : 'Hallo, Guest',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4E2A00),
                            ),
                          ),
                          Text(
                            user != null && user.email.isNotEmpty
                                ? '@${user.email.split('@').first}'
                                : '@guest',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFD5A87B),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Add logout functionality or navigate to profile
                          if (isLoggedIn) {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                      'Are you sure you want to logout?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(authProvider.notifier)
                                              .logout();
                                          Navigator.pop(context);
                                          context.go('/welcome');
                                        },
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  ),
                            );
                          }
                        },
                        child: CircleAvatar(
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
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Home page content
              const HomeWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeWidget extends ConsumerWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuItemsProvider);
    final isLoading = ref.watch(menuLoadingProvider);
    final errorMessage = ref.watch(menuErrorProvider);

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

        // Order Verification Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () => context.push('/order_verification'),
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cek Status Pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Lacak pesanan dan status pembayaran Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Menu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF754414),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Show loading, error, or menu items
        if (errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(menuProvider.notifier).loadMenuItems();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          )
        else if (isLoading && menuItems.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (menuItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: Text(
                'No menu items available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                menuItems.take(4).map((menuItem) {
                  return MenuCard(
                    imageUrl: menuItem.image ?? 'assets/image/menu.png',
                    title: menuItem.name ?? 'Unknown Item',
                    category: menuItem.category ?? 'Other',
                    nameresto:
                        'Restaurant', // You can add restaurant name to MenuItem if needed
                    price:
                        menuItem.price != null
                            ? 'Rp${menuItem.price}'
                            : 'Price not available',
                  );
                }).toList(),
          ),
      ],
    );
  }
}
