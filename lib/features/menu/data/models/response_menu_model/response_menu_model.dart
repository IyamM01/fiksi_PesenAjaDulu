import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'restaurant.dart';

part 'response_menu_model.g.dart';

@JsonSerializable()
class ResponseMenuModel extends Equatable {
  final int? id;
  final String? name;
  @JsonKey(name: 'restaurant_id')
  final int? restaurantId;
  final String? description;
  final int? stock;
  final String? image;
  final String? price;
  final String? category;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final Restaurant? restaurant;

  const ResponseMenuModel({
    this.id,
    this.name,
    this.restaurantId,
    this.description,
    this.stock,
    this.image,
    this.price,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.restaurant,
  });

  factory ResponseMenuModel.fromJson(Map<String, dynamic> json) {
    return _$ResponseMenuModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResponseMenuModelToJson(this);

  ResponseMenuModel copyWith({
    int? id,
    String? name,
    int? restaurantId,
    String? description,
    int? stock,
    String? image,
    String? price,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    Restaurant? restaurant,
  }) {
    return ResponseMenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      restaurantId: restaurantId ?? this.restaurantId,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      restaurantId,
      description,
      stock,
      image,
      price,
      category,
      createdAt,
      updatedAt,
      restaurant,
    ];
  }
}
