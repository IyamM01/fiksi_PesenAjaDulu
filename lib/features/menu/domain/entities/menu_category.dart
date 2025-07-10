enum MenuCategory {
  mainCourse('Main Course'),
  appetizer('Appetizer'),
  dessert('Dessert'),
  beverage('Beverage'),
  snack('Snack');

  const MenuCategory(this.displayName);
  final String displayName;
}
