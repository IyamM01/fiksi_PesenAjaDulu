// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  id: (json['id'] as num?)?.toInt(),
  orderId: json['order_id'] as String?,
  menuId: (json['menu_id'] as num?)?.toInt(),
  quantity: (json['quantity'] as num?)?.toInt(),
  price: (json['price'] as num?)?.toInt(),
  menu:
      json['menu'] == null
          ? null
          : Menu.fromJson(json['menu'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'menu_id': instance.menuId,
  'quantity': instance.quantity,
  'price': instance.price,
  'menu': instance.menu,
};
