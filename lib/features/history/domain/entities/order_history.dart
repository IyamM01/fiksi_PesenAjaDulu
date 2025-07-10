class OrderHistory {
  final String id;
  final String orderId;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImage;
  final String tableNumber;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final DateTime? completedDate;
  final int itemCount;

  const OrderHistory({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.tableNumber,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.completedDate,
    required this.itemCount,
  });

  OrderHistory copyWith({
    String? id,
    String? orderId,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImage,
    String? tableNumber,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
    DateTime? completedDate,
    int? itemCount,
  }) {
    return OrderHistory(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImage: restaurantImage ?? this.restaurantImage,
      tableNumber: tableNumber ?? this.tableNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      completedDate: completedDate ?? this.completedDate,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrderHistory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
