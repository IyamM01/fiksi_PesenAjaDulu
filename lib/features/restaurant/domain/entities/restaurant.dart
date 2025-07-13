import 'table.dart';

class Restaurant {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final String? address;
  final double? rating;
  final String? phoneNumber;
  final bool? isOpen;
  final List<RestaurantTable>? tables;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Restaurant({
    this.id,
    this.name,
    this.description,
    this.image,
    this.address,
    this.rating,
    this.phoneNumber,
    this.isOpen,
    this.tables,
    this.createdAt,
    this.updatedAt,
  });

  // Computed properties
  bool get isAvailable => isOpen ?? false;
  String get displayRating =>
      rating != null ? rating!.toStringAsFixed(1) : '0.0';

  List<RestaurantTable> get availableTables =>
      tables?.where((table) => table.isAvailable).toList() ?? [];

  List<RestaurantTable> get occupiedTables =>
      tables?.where((table) => table.isOccupied).toList() ?? [];

  List<RestaurantTable> get reservedTables =>
      tables?.where((table) => table.isReserved).toList() ?? [];

  int get totalTables => tables?.length ?? 0;
  int get availableTableCount => availableTables.length;

  Restaurant copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? address,
    double? rating,
    String? phoneNumber,
    bool? isOpen,
    List<RestaurantTable>? tables,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      address: address ?? this.address,
      rating: rating ?? this.rating,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOpen: isOpen ?? this.isOpen,
      tables: tables ?? this.tables,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    List<RestaurantTable>? tablesList;
    if (json['tables'] != null) {
      final tablesJson = json['tables'] as List<dynamic>;
      tablesList =
          tablesJson
              .map((tableJson) => RestaurantTable.fromJson(tableJson))
              .toList();
    }

    return Restaurant(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      address: json['address'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      phoneNumber: json['phone_number'] as String?,
      isOpen: json['is_open'] as bool?,
      tables: tablesList,
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

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'address': address,
      'rating': rating,
      'phone_number': phoneNumber,
      'is_open': isOpen,
      'tables': tables?.map((table) => table.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, rating: $displayRating, isOpen: $isOpen)';
  }
}
