// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Table _$TableFromJson(Map<String, dynamic> json) => Table(
  id: (json['id'] as num?)?.toInt(),
  number: json['number'] as String?,
  seats: (json['seats'] as num?)?.toInt(),
);

Map<String, dynamic> _$TableToJson(Table instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'seats': instance.seats,
};
