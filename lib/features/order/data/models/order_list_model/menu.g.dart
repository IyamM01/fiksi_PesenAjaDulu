// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  price: (json['price'] as num?)?.toInt(),
);

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
};
