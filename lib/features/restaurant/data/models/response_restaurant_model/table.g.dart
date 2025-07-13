// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
  id: (json['id'] as num?)?.toInt(),
  restaurantId: (json['restaurant_id'] as num?)?.toInt(),
  status: json['status'] as String?,
  capacity: (json['capacity'] as num?)?.toInt(),
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
  'id': instance.id,
  'restaurant_id': instance.restaurantId,
  'status': instance.status,
  'capacity': instance.capacity,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
