import '../entities/order.dart';
import '../entities/order_item.dart';
import '../repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Order> call({
    required String userId,
    required String restaurantId,
    required String restaurantName,
    required String tableNumber,
    required List<OrderItem> items,
    String? notes,
  }) async {
    return await repository.createOrder(
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      tableNumber: tableNumber,
      items: items,
      notes: notes,
    );
  }
}
