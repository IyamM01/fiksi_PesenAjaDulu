// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_menu_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseMenuModel _$ResponseMenuModelFromJson(Map<String, dynamic> json) =>
    ResponseMenuModel(
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
      restaurant:
          json['restaurant'] == null
              ? null
              : Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseMenuModelToJson(ResponseMenuModel instance) =>
    <String, dynamic>{
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
      'restaurant': instance.restaurant,
    };
