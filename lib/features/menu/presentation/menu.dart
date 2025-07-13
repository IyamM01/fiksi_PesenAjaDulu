import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';
import 'package:flutter_fiksi/features/menu/presentation/providers/menu_provider.dart';

class Menu extends ConsumerStatefulWidget {
  const Menu({super.key});

  @override
  ConsumerState<Menu> createState() => _MenuState();
}

class _MenuState extends ConsumerState<Menu> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load menu items when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuProvider.notifier).loadMenuItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      ref.read(menuProvider.notifier).loadMenuItems();
    } else {
      ref.read(menuProvider.notifier).searchMenuItems(query);
    }
  }

  void _onCategorySelected(String category) {
    if (category == 'All') {
      ref.read(menuProvider.notifier).loadMenuItems();
    } else {
      ref.read(menuProvider.notifier).loadMenuItemsByCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuItemsProvider);
    final isLoading = ref.watch(menuLoadingProvider);
    final errorMessage = ref.watch(menuErrorProvider);
    final availableCategories = ref.watch(availableCategoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFCECDC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF754414)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Menu',
          style: TextStyle(
            color: Color(0xFF754414),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
                      color: Colors.black.withOpacity(0.08),
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
                    hintText: 'Search menu items...',
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

              // Category navigation
              NavCategory(
                selectedCategory: selectedCategory,
                onCategorySelected: _onCategorySelected,
                categories: availableCategories,
              ),
              const SizedBox(height: 24),

              // Content area
              Expanded(
                child: _buildContent(menuItems, isLoading, errorMessage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    List<dynamic> menuItems,
    bool isLoading,
    String? errorMessage,
  ) {
    // Loading indicator
    if (isLoading && menuItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFE7F00), strokeWidth: 3),
            SizedBox(height: 16),
            Text(
              'Loading menu items...',
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
                  ref.read(menuProvider.notifier).loadMenuItems();
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
    if (menuItems.isEmpty) {
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
              Icon(
                Icons.restaurant_menu,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No menu items found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or category filter',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    // Menu items list
    return Column(
      children: [
        // Header with count and loading indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${menuItems.length} items found',
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

        // Menu items list
        Expanded(
          child: ListView.separated(
            itemCount: menuItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final menuItem = menuItems[index];
              return GestureDetector(
                onTap: () => MenuDescriptionPopup.show(
                  context: context,
                  title: menuItem.name ?? 'Unknown Item',
                  nameresto: 'Restaurant',
                  description: menuItem.description ?? 'No description available.',
                  imageUrl: menuItem.image,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: MenuItemCard(
                    imageUrl: menuItem.image ?? 'assets/image/menu.png',
                    title: menuItem.name ?? 'Unknown Item',
                    category: menuItem.category ?? 'Other',
                    price: menuItem.price != null
                        ? 'Rp${menuItem.price}'
                        : 'Price not available',
                    menuItem: menuItem,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
