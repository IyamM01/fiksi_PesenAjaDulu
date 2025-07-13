import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'menu.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem extends Equatable {
  final int? id;
  @JsonKey(name: 'order_id')
  final String? orderId;
  @JsonKey(name: 'menu_id')
  final int? menuId;
  final int? quantity;
  final int? price;
  final Menu? menu;

  const OrderItem({
    this.id,
    this.orderId,
    this.menuId,
    this.quantity,
    this.price,
    this.menu,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return _$OrderItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItem copyWith({
    int? id,
    String? orderId,
    int? menuId,
    int? quantity,
    int? price,
    Menu? menu,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuId: menuId ?? this.menuId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      menu: menu ?? this.menu,
    );
  }

  @override
  List<Object?> get props => [id, orderId, menuId, quantity, price, menu];
}
