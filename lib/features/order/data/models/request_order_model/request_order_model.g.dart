// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestOrderModel _$RequestOrderModelFromJson(Map<String, dynamic> json) =>
    RequestOrderModel(
      userId: (json['user_id'] as num?)?.toInt(),
      tableId: (json['table_id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      reservationTime: json['reservation_time'] as String?,
      orderItems:
          (json['order_items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$RequestOrderModelToJson(RequestOrderModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'table_id': instance.tableId,
      'amount': instance.amount,
      'reservation_time': instance.reservationTime,
      'order_items': instance.orderItems?.map((e) => e.toJson()).toList(),
    };
