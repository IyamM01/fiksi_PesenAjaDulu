import '../entities/order_history.dart';

abstract class HistoryRepository {
  Future<List<OrderHistory>> getOrderHistory(String userId);
  Future<OrderHistory> getOrderHistoryById(String orderId);
  Future<List<OrderHistory>> getOrderHistoryByStatus(
    String userId,
    String status,
  );
}
