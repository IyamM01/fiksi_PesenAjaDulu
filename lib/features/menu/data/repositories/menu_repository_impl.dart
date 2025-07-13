import '../../domain/repositories/menu_repository.dart';
import '../../domain/entities/menu_item.dart';
import '../datasources/menu_remote_datasource.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDatasource _remoteDatasource;

  MenuRepositoryImpl({MenuRemoteDatasource? remoteDatasource})
    : _remoteDatasource = remoteDatasource ?? MenuRemoteDatasourceImpl();

  @override
  Future<List<MenuItem>> getMenuItems() async {
    try {
      return await _remoteDatasource.getMenuItems();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByRestaurant(String restaurantId) async {
    try {
      final id = int.tryParse(restaurantId);
      if (id == null) {
        throw ValidationException(message: 'Invalid restaurant ID');
      }
      return await _remoteDatasource.getMenuItemsByRestaurant(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      return await _remoteDatasource.getMenuItemsByCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MenuItem> getMenuItemById(String id) async {
    try {
      final menuItems = await _remoteDatasource.getMenuItems();
      final itemId = int.tryParse(id);
      if (itemId == null) {
        throw ValidationException(message: 'Invalid menu item ID');
      }

      final item = menuItems.firstWhere(
        (item) => item.id == itemId,
        orElse: () => throw NotFoundException(message: 'Menu item not found'),
      );

      return item;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    try {
      final menuItems = await _remoteDatasource.getMenuItems();
      final searchQuery = query.toLowerCase();

      return menuItems.where((item) {
        final name = item.name?.toLowerCase() ?? '';
        final description = item.description?.toLowerCase() ?? '';
        final category = item.category?.toLowerCase() ?? '';

        return name.contains(searchQuery) ||
            description.contains(searchQuery) ||
            category.contains(searchQuery);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
