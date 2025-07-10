import '../entities/restaurant_table.dart';
import '../repositories/table_repository.dart';

class GetAvailableTablesUseCase {
  final TableRepository repository;

  GetAvailableTablesUseCase(this.repository);

  Future<List<RestaurantTable>> call(String restaurantId) async {
    return await repository.getAvailableTables(restaurantId);
  }
}
