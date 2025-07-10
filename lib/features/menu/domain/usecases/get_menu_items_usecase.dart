import '../entities/menu_item.dart';
import '../repositories/menu_repository.dart';

class GetMenuItemsUseCase {
  final MenuRepository repository;

  GetMenuItemsUseCase(this.repository);

  Future<List<MenuItem>> call() async {
    return await repository.getMenuItems();
  }
}
