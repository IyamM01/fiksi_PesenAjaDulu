import 'package:flutter/material.dart';

class NavCategory extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final List<String> categories;

  const NavCategory({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.categories = const [
      'All',
      'Main Course',
      'Beverage',
      'Soup',
      'Salad',
      'Dessert',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFE7F00) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFFFE7F00)
                          : const Color(0xFFE0E0E0),
                  width: 1.5,
                ),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: const Color(0xFFFE7F00).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF754414),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
