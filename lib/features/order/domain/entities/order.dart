import 'order_item.dart';

enum OrderStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  preparing('Preparing'),
  ready('Ready'),
  completed('Completed'),
  cancelled('Cancelled');

  const OrderStatus(this.displayName);
  final String displayName;
}

class Order {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String tableNumber;
  final List<OrderItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime orderTime;
  final DateTime? completedTime;
  final String? notes;

  const Order({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.tableNumber,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.orderTime,
    this.completedTime,
    this.notes,
  });

  Order copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? tableNumber,
    List<OrderItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? orderTime,
    DateTime? completedTime,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      tableNumber: tableNumber ?? this.tableNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      orderTime: orderTime ?? this.orderTime,
      completedTime: completedTime ?? this.completedTime,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
