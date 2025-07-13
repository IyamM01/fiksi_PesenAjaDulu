// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num?)?.toInt(),
  orderId: json['order_id'] as String?,
  method: json['method'] as String?,
  status: json['status'] as String?,
  amountPaid: (json['amount_paid'] as num?)?.toInt(),
  paidAt:
      json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'method': instance.method,
  'status': instance.status,
  'amount_paid': instance.amountPaid,
  'paid_at': instance.paidAt?.toIso8601String(),
};
