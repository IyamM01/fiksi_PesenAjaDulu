// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListModel _$OrderListModelFromJson(Map<String, dynamic> json) =>
    OrderListModel(
      id: json['id'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      tableId: (json['table_id'] as num?)?.toInt(),
      status: json['status'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      reservationTime:
          json['reservation_time'] == null
              ? null
              : DateTime.parse(json['reservation_time'] as String),
      advanceAmount: (json['advance_amount'] as num?)?.toInt(),
      remainingAmount: (json['remaining_amount'] as num?)?.toInt(),
      user:
          json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>),
      table:
          json['table'] == null
              ? null
              : Table.fromJson(json['table'] as Map<String, dynamic>),
      orderItems:
          (json['order_items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      payment:
          json['payment'] == null
              ? null
              : Payment.fromJson(json['payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderListModelToJson(OrderListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'table_id': instance.tableId,
      'status': instance.status,
      'amount': instance.amount,
      'reservation_time': instance.reservationTime?.toIso8601String(),
      'advance_amount': instance.advanceAmount,
      'remaining_amount': instance.remainingAmount,
      'user': instance.user,
      'table': instance.table,
      'order_items': instance.orderItems,
      'payment': instance.payment,
    };
