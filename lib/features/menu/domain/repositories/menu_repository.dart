import '../entities/menu_item.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems();
  Future<List<MenuItem>> getMenuItemsByRestaurant(String restaurantId);
  Future<List<MenuItem>> getMenuItemsByCategory(String category);
  Future<MenuItem> getMenuItemById(String id);
  Future<List<MenuItem>> searchMenuItems(String query);
}
