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
      'Drinks',
      'Dessert',
      'Snacks',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selectedCategory == category
                              ? const Color(0xFFFF7F00)
                              : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color:
                            selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
