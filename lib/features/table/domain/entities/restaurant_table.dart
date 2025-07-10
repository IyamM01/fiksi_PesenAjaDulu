enum TableStatus {
  available('Available'),
  occupied('Occupied'),
  reserved('Reserved'),
  maintenance('Maintenance');

  const TableStatus(this.displayName);
  final String displayName;
}

class RestaurantTable {
  final String id;
  final String number;
  final String restaurantId;
  final int capacity;
  final TableStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RestaurantTable({
    required this.id,
    required this.number,
    required this.restaurantId,
    required this.capacity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  RestaurantTable copyWith({
    String? id,
    String? number,
    String? restaurantId,
    int? capacity,
    TableStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      number: number ?? this.number,
      restaurantId: restaurantId ?? this.restaurantId,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RestaurantTable && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
