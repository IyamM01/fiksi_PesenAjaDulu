import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fiksi/shared/widgets/widgets.dart';
import 'package:flutter_fiksi/features/menu/presentation/providers/menu_provider.dart';
import 'package:flutter_fiksi/features/order/presentation/providers/order_provider.dart';

class OrderMenuPage extends ConsumerStatefulWidget {
  final String? restaurantId;
  final String? restaurantName;

  const OrderMenuPage({super.key, this.restaurantId, this.restaurantName});

  @override
  ConsumerState<OrderMenuPage> createState() => _OrderMenuPageState();
}

class _OrderMenuPageState extends ConsumerState<OrderMenuPage> {
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load menu items when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuProvider.notifier).loadMenuItems();

      // Set restaurant context if provided
      if (widget.restaurantId != null && widget.restaurantName != null) {
        ref
            .read(orderProvider.notifier)
            .setRestaurant(widget.restaurantId!, widget.restaurantName!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      ref.read(menuProvider.notifier).loadMenuItems();
    } else {
      ref.read(menuProvider.notifier).searchMenuItems(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuItemsProvider);
    final isLoading = ref.watch(menuLoadingProvider);
    final errorMessage = ref.watch(menuErrorProvider);
    final orderTotalItems = ref.watch(orderTotalItemsProvider);

    // Filter by category
    final filteredMenuItems =
        selectedCategory == 'All'
            ? menuItems
            : menuItems
                .where((item) => item.category == selectedCategory)
                .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFE7F00)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            // Search bar
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
                  controller: _searchController,
                  onChanged: _onSearch,
                  decoration: const InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.search, color: Color(0xFF504F5E)),
                    ),
                    hintText: 'Search menu...',
                    fillColor: Color(0xFF504F5E),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category navigation
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

            // Loading indicator
            if (isLoading && menuItems.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            // Error message
            else if (errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(menuProvider.notifier).loadMenuItems();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            // Empty state
            else if (filteredMenuItems.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No menu items found',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            // Menu items list
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredMenuItems.length,
                  itemBuilder: (context, index) {
                    final menuItem = filteredMenuItems[index];
                    return GestureDetector(
                      onTap:
                          () => MenuDescriptionPopup.show(
                            context: context,
                            title: menuItem.name ?? 'Unknown Item',
                            nameresto: widget.restaurantName ?? 'Restaurant',
                            description:
                                menuItem.description ??
                                'No description available',
                            imageUrl: menuItem.image,
                          ),
                      child: MenuItemCard(
                        imageUrl: menuItem.image ?? '',
                        category: menuItem.category ?? '',
                        title: menuItem.name ?? '',
                        price: menuItem.price ?? '',
                        menuItem: menuItem,
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 24),

            // Next button with cart indicator
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed:
                    orderTotalItems > 0
                        ? () {
                          context.push('/table_order');
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      orderTotalItems > 0 ? Colors.orange : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (orderTotalItems > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$orderTotalItems',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 55),
          ],
        ),
      ),
    );
  }
}
