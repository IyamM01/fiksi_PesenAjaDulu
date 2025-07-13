// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  restaurantId: (json['restaurant_id'] as num?)?.toInt(),
  description: json['description'] as String?,
  stock: (json['stock'] as num?)?.toInt(),
  image: json['image'] as String?,
  price: json['price'] as String?,
  category: json['category'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'restaurant_id': instance.restaurantId,
  'description': instance.description,
  'stock': instance.stock,
  'image': instance.image,
  'price': instance.price,
  'category': instance.category,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
