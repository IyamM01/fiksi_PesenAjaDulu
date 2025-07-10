import '../entities/restaurant_table.dart';

abstract class TableRepository {
  Future<List<RestaurantTable>> getTablesByRestaurant(String restaurantId);
  Future<List<RestaurantTable>> getAvailableTables(String restaurantId);
  Future<RestaurantTable> getTableById(String tableId);
  Future<RestaurantTable> updateTableStatus(String tableId, TableStatus status);
}
