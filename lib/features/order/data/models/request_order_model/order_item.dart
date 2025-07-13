import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItem extends Equatable {
  @JsonKey(name: 'menu_id')
  final int? menuId;
  final int? quantity;
  final int? price;

  const OrderItem({this.menuId, this.quantity, this.price});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return _$OrderItemFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);

  OrderItem copyWith({int? menuId, int? quantity, int? price}) {
    return OrderItem(
      menuId: menuId ?? this.menuId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [menuId, quantity, price];
}
