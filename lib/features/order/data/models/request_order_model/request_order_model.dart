import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_item.dart';

part 'request_order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RequestOrderModel extends Equatable {
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'table_id')
  final int? tableId;
  final int? amount;
  @JsonKey(name: 'reservation_time')
  final String? reservationTime;
  @JsonKey(name: 'order_items')
  final List<OrderItem>? orderItems;

  const RequestOrderModel({
    this.userId,
    this.tableId,
    this.amount,
    this.reservationTime,
    this.orderItems,
  });

  factory RequestOrderModel.fromJson(Map<String, dynamic> json) {
    return _$RequestOrderModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RequestOrderModelToJson(this);

  RequestOrderModel copyWith({
    int? userId,
    int? tableId,
    int? amount,
    String? reservationTime,
    List<OrderItem>? orderItems,
  }) {
    return RequestOrderModel(
      userId: userId ?? this.userId,
      tableId: tableId ?? this.tableId,
      amount: amount ?? this.amount,
      reservationTime: reservationTime ?? this.reservationTime,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  @override
  List<Object?> get props {
    return [userId, tableId, amount, reservationTime, orderItems];
  }
}
