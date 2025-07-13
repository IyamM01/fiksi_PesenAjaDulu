import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String nameresto;
  final String price;

  const MenuCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.nameresto,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image container
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageUrl.startsWith('http')
                    ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/image/menu.png',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFE7F00),
                            ),
                          ),
                        );
                      },
                    )
                    : Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade100,
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.grey.shade400,
                            size: 32,
                          ),
                        );
                      },
                    ),
          ),
        ),
        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4E2A00),
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Category
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFE7F00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFE7F00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 4),

              // Restaurant name
              Text(
                nameresto,
                style: const TextStyle(fontSize: 13, color: Color(0xFF754414)),
              ),
              const SizedBox(height: 6),

              // Price
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFFFE7F00),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
