import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_item.dart';
import 'payment.dart';
import 'table.dart';
import 'user.dart';

part 'order_list_model.g.dart';

@JsonSerializable()
class OrderListModel extends Equatable {
  final String? id;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'table_id')
  final int? tableId;
  final String? status;
  final int? amount;
  @JsonKey(name: 'reservation_time')
  final DateTime? reservationTime;
  @JsonKey(name: 'advance_amount')
  final int? advanceAmount;
  @JsonKey(name: 'remaining_amount')
  final int? remainingAmount;
  final User? user;
  final Table? table;
  @JsonKey(name: 'order_items')
  final List<OrderItem>? orderItems;
  final Payment? payment;

  const OrderListModel({
    this.id,
    this.userId,
    this.tableId,
    this.status,
    this.amount,
    this.reservationTime,
    this.advanceAmount,
    this.remainingAmount,
    this.user,
    this.table,
    this.orderItems,
    this.payment,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) {
    return _$OrderListModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OrderListModelToJson(this);

  OrderListModel copyWith({
    String? id,
    int? userId,
    int? tableId,
    String? status,
    int? amount,
    DateTime? reservationTime,
    int? advanceAmount,
    int? remainingAmount,
    User? user,
    Table? table,
    List<OrderItem>? orderItems,
    Payment? payment,
  }) {
    return OrderListModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tableId: tableId ?? this.tableId,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      reservationTime: reservationTime ?? this.reservationTime,
      advanceAmount: advanceAmount ?? this.advanceAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      user: user ?? this.user,
      table: table ?? this.table,
      orderItems: orderItems ?? this.orderItems,
      payment: payment ?? this.payment,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      tableId,
      status,
      amount,
      reservationTime,
      advanceAmount,
      remainingAmount,
      user,
      table,
      orderItems,
      payment,
    ];
  }
}
