import '../entities/order_history.dart';
import '../repositories/history_repository.dart';

class GetOrderHistoryUseCase {
  final HistoryRepository repository;

  GetOrderHistoryUseCase(this.repository);

  Future<List<OrderHistory>> call(String userId) async {
    return await repository.getOrderHistory(userId);
  }
}
