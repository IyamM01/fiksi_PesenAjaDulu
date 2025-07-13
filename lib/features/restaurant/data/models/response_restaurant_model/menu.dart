import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'menu.g.dart';

@JsonSerializable()
class Menu extends Equatable {
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

  const Menu({
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
  });

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  Menu copyWith({
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
  }) {
    return Menu(
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
    ];
  }
}
