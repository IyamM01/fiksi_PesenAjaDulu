// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseRestaurantModel _$ResponseRestaurantModelFromJson(
  Map<String, dynamic> json,
) => ResponseRestaurantModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  address: json['address'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  description: json['description'] as String?,
  logo: json['logo'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  menus:
      (json['menus'] as List<dynamic>?)
          ?.map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList(),
  tables:
      (json['tables'] as List<dynamic>?)
          ?.map((e) => Table.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ResponseRestaurantModelToJson(
  ResponseRestaurantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'phone': instance.phone,
  'email': instance.email,
  'description': instance.description,
  'logo': instance.logo,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'menus': instance.menus,
  'tables': instance.tables,
};
