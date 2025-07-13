class MenuItem {
  final int? id;
  final String? name;
  final String? description;
  final String? image;
  final String? price; // API returns price as string
  final String? category;
  final int? restaurantId; // API uses int for restaurant_id
  final int? stock;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MenuItem({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.category,
    this.restaurantId,
    this.stock,
    this.createdAt,
    this.updatedAt,
  });

  // Computed property for availability based on stock
  bool get isAvailable => stock != null && stock! > 0;

  // Computed property for price as double
  double get priceAsDouble {
    if (price == null || price!.isEmpty) return 0.0;
    return double.tryParse(price!) ?? 0.0;
  }

  MenuItem copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    String? price,
    String? category,
    int? restaurantId,
    int? stock,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      restaurantId: restaurantId ?? this.restaurantId,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convert from ResponseMenuModel to MenuItem
  factory MenuItem.fromResponseModel(dynamic responseModel) {
    if (responseModel == null) {
      throw ArgumentError('ResponseModel cannot be null');
    }

    return MenuItem(
      id: responseModel.id,
      name: responseModel.name,
      description: responseModel.description,
      image: responseModel.image,
      price: responseModel.price,
      category: responseModel.category,
      restaurantId: responseModel.restaurantId,
      stock: responseModel.stock,
      createdAt: responseModel.createdAt,
      updatedAt: responseModel.updatedAt,
    );
  }

  // Convert from JSON
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      price: json['price'] as String?,
      category: json['category'] as String?,
      restaurantId: json['restaurant_id'] as int?,
      stock: json['stock'] as int?,
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
      'price': price,
      'category': category,
      'restaurant_id': restaurantId,
      'stock': stock,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuItem(id: $id, name: $name, price: $price, category: $category, stock: $stock, isAvailable: $isAvailable)';
  }
}
