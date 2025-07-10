import '../entities/order.dart';
import '../entities/order_item.dart';

abstract class OrderRepository {
  Future<Order> createOrder({
    required String userId,
    required String restaurantId,
    required String restaurantName,
    required String tableNumber,
    required List<OrderItem> items,
    String? notes,
  });

  Future<List<Order>> getOrdersByUser(String userId);
  Future<Order> getOrderById(String orderId);
  Future<Order> updateOrderStatus(String orderId, OrderStatus status);
  Future<void> cancelOrder(String orderId);
}
