import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment extends Equatable {
  final int? id;
  @JsonKey(name: 'order_id')
  final String? orderId;
  final String? method;
  final String? status;
  @JsonKey(name: 'amount_paid')
  final int? amountPaid;
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;

  const Payment({
    this.id,
    this.orderId,
    this.method,
    this.status,
    this.amountPaid,
    this.paidAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return _$PaymentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  Payment copyWith({
    int? id,
    String? orderId,
    String? method,
    String? status,
    int? amountPaid,
    DateTime? paidAt,
  }) {
    return Payment(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      method: method ?? this.method,
      status: status ?? this.status,
      amountPaid: amountPaid ?? this.amountPaid,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  @override
  List<Object?> get props {
    return [id, orderId, method, status, amountPaid, paidAt];
  }
}
