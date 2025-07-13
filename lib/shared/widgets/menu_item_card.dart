import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fiksi/features/menu/domain/entities/menu_item.dart';
import 'package:flutter_fiksi/features/order/presentation/providers/order_provider.dart';

class MenuItemCard extends ConsumerWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String price;
  final MenuItem menuItem;

  const MenuItemCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current quantity for this menu item from order state
    final orderState = ref.watch(orderProvider);
    final currentQuantity = orderState.items
        .where((item) => item.menuItemId == menuItem.id?.toString())
        .fold(0, (sum, item) => sum + item.quantity);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child:
                  imageUrl.isNotEmpty
                      ? (imageUrl.startsWith('http')
                          ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          )
                          : Image.asset(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ))
                      : _buildPlaceholderImage(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFE7F00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4E2A00),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price.startsWith('Rp') ? price : 'Rp$price',
                  style: const TextStyle(
                    color: Color(0xFFFE7F00),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove,
                    color: currentQuantity > 0 
                        ? const Color(0xFFFE7F00) 
                        : Colors.grey,
                    size: 20,
                  ),
                  onPressed: currentQuantity > 0
                      ? () {
                          ref
                              .read(orderProvider.notifier)
                              .decreaseQuantity(menuItem.id?.toString() ?? '');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Removed ${menuItem.name} from cart!',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      : null,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 32),
                  child: Text(
                    currentQuantity.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF754414),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Color(0xFFFE7F00),
                    size: 20,
                  ),
                  onPressed: () {
                    ref.read(orderProvider.notifier).addItem(menuItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${menuItem.name} added to cart!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.restaurant_menu, size: 32, color: Colors.grey),
      ),
    );
  }
}
