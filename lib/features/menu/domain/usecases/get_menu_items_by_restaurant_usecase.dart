import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class GetMenuItemsByRestaurantUseCase {
  final MenuRepository repository;

  GetMenuItemsByRestaurantUseCase(this.repository);

  Future<List<MenuItem>> call(String restaurantId) async {
    return await repository.getMenuItemsByRestaurant(restaurantId);
  }
}
