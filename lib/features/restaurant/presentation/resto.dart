import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/providers/restaurant_provider.dart';

class Resto extends ConsumerStatefulWidget {
  const Resto({super.key});

  @override
  ConsumerState<Resto> createState() => _RestoState();
}

class _RestoState extends ConsumerState<Resto> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load restaurants when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(restaurantProvider.notifier).loadRestaurants();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      ref.read(restaurantProvider.notifier).loadRestaurants();
    } else {
      ref.read(restaurantProvider.notifier).searchRestaurants(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = ref.watch(restaurantsProvider);
    final isLoading = ref.watch(restaurantLoadingProvider);
    final errorMessage = ref.watch(restaurantErrorProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCECDC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Select Restaurants',
          style: TextStyle(
            color: Color(0xFF754414),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: const TextStyle(
                    color: Color(0xFF754414),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search restaurants...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF754414),
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF754414),
                      size: 22,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFFE7F00),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Filter options
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(restaurantProvider.notifier).loadRestaurants();
                      },
                      icon: const Icon(Icons.restaurant, size: 18),
                      label: const Text('All Restaurants'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF754414),
                        elevation: 2,
                        shadowColor: Colors.black.withValues(alpha: 0.1),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _searchController.clear();
                        ref
                            .read(restaurantProvider.notifier)
                            .loadRestaurantsByRating(4.0);
                      },
                      icon: const Icon(Icons.star, size: 18),
                      label: const Text('Top Rated'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFE7F00),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: const Color(
                          0xFFFE7F00,
                        ).withValues(alpha: 0.3),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Content area
              Expanded(
                child: _buildContent(restaurants, isLoading, errorMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    List<dynamic> restaurants,
    bool isLoading,
    String? errorMessage,
  ) {
    // Loading indicator
    if (isLoading && restaurants.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFE7F00), strokeWidth: 3),
            SizedBox(height: 16),
            Text(
              'Loading restaurants...',
              style: TextStyle(color: Color(0xFF754414), fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Error message
    if (errorMessage != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade600, size: 48),
              const SizedBox(height: 12),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(restaurantProvider.notifier).loadRestaurants();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE7F00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (restaurants.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No restaurants found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    // Restaurants list
    return Column(
      children: [
        // Header with count and loading indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${restaurants.length} restaurants found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF754414),
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFFE7F00),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Restaurants grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  // Navigate to order menu page with restaurant context
                  context.push(
                    '/order_menu',
                    extra: {
                      'restaurantId': restaurant.id?.toString(),
                      'restaurantName': restaurant.name,
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
