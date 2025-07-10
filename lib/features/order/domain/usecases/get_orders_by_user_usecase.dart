import '../entities/order.dart';
import '../repositories/order_repository.dart';

class GetOrdersByUserUseCase {
  final OrderRepository repository;

  GetOrdersByUserUseCase(this.repository);

  Future<List<Order>> call(String userId) async {
    return await repository.getOrdersByUser(userId);
  }
}
