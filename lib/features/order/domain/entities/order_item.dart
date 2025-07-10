class OrderItem {
  final String id;
  final String menuItemId;
  final String menuItemName;
  final String menuItemImage;
  final double price;
  final int quantity;
  final String? notes;

  const OrderItem({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.menuItemImage,
    required this.price,
    required this.quantity,
    this.notes,
  });

  OrderItem copyWith({
    String? id,
    String? menuItemId,
    String? menuItemName,
    String? menuItemImage,
    double? price,
    int? quantity,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      menuItemName: menuItemName ?? this.menuItemName,
      menuItemImage: menuItemImage ?? this.menuItemImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => price * quantity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
