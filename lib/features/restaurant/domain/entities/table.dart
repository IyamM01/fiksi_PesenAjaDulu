class RestaurantTable {
  final int? id;
  final int? restaurantId;
  final String? status; // occupied, reserved, available
  final int? capacity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RestaurantTable({
    this.id,
    this.restaurantId,
    this.status,
    this.capacity,
    this.createdAt,
    this.updatedAt,
  });

  // Computed properties
  bool get isAvailable => status == 'available';
  bool get isOccupied => status == 'occupied';
  bool get isReserved => status == 'reserved';

  String get displayName => 'Table ${id ?? 0}';
  String get statusDisplay => status?.toUpperCase() ?? 'UNKNOWN';

  RestaurantTable copyWith({
    int? id,
    int? restaurantId,
    String? status,
    int? capacity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      status: status ?? this.status,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      id: json['id'] as int?,
      restaurantId: json['restaurant_id'] as int?,
      status: json['status'] as String?,
      capacity: json['capacity'] as int?,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
      updatedAt:
          json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'status': status,
      'capacity': capacity,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RestaurantTable &&
        other.id == id &&
        other.restaurantId == restaurantId &&
        other.status == status &&
        other.capacity == capacity;
  }

  @override
  int get hashCode {
    return Object.hash(id, restaurantId, status, capacity);
  }

  @override
  String toString() {
    return 'RestaurantTable(id: $id, restaurantId: $restaurantId, status: $status, capacity: $capacity)';
  }
}
