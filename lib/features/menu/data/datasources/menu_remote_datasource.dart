import 'package:flutter_fiksi/features/menu/domain/entities/menu_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fiksi/core/di/dependency_injection.dart';
import 'package:flutter_fiksi/core/constants/app_constants.dart';
import 'package:flutter_fiksi/core/exceptions/app_exceptions.dart';

abstract class MenuRemoteDatasource {
  Future<List<MenuItem>> getMenuItems();
  Future<List<MenuItem>> getMenuItemsByRestaurant(int restaurantId);
  Future<List<MenuItem>> getMenuItemsByCategory(String category);
}

class MenuRemoteDatasourceImpl implements MenuRemoteDatasource {
  final Dio _dio;

  MenuRemoteDatasourceImpl({Dio? dio}) : _dio = dio ?? sl<Dio>();

  @override
  Future<List<MenuItem>> getMenuItems() async {
    try {
      final response = await _dio.get(ApiConstants.menuEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> menuData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['menus'] ?? [];

        return menuData.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch menu items');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return mock data for testing when server is not available
        return _getMockMenuItems();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch menu items: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred while fetching menu items',
      );
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByRestaurant(int restaurantId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.menuEndpoint}?restaurant_id=$restaurantId',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> menuData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['menus'] ?? [];

        return menuData.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch menu items for restaurant',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return filtered mock data
        return _getMockMenuItems()
            .where((item) => item.restaurantId == restaurantId)
            .toList();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch restaurant menu: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred while fetching restaurant menu',
      );
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String category) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.menuEndpoint}?category=$category',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> menuData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['menus'] ?? [];

        return menuData.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch menu items by category',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return filtered mock data
        return _getMockMenuItems()
            .where(
              (item) => item.category?.toLowerCase() == category.toLowerCase(),
            )
            .toList();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch menu by category: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred while fetching menu by category',
      );
    }
  }

  // Mock data for testing when API is not available
  List<MenuItem> _getMockMenuItems() {
    return [
      MenuItem(
        id: 1,
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng dengan telur, ayam, dan sayuran segar',
        image: 'assets/image/menu.png',
        price: '25000',
        category: 'Main Course',
        restaurantId: 1,
        stock: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
      MenuItem(
        id: 2,
        name: 'Ayam Bakar Madu',
        description: 'Ayam bakar dengan bumbu madu yang manis dan gurih',
        image: 'assets/image/menu.png',
        price: '35000',
        category: 'Main Course',
        restaurantId: 1,
        stock: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
      MenuItem(
        id: 3,
        name: 'Soto Ayam',
        description: 'Soto ayam tradisional dengan kuah yang kaya rempah',
        image: 'assets/image/menu.png',
        price: '20000',
        category: 'Soup',
        restaurantId: 1,
        stock: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now(),
      ),
      MenuItem(
        id: 4,
        name: 'Es Teh Manis',
        description: 'Minuman teh manis segar dengan es batu',
        image: 'assets/image/menu.png',
        price: '8000',
        category: 'Beverage',
        restaurantId: 1,
        stock: 20,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
      ),
      MenuItem(
        id: 5,
        name: 'Gado-Gado',
        description: 'Salad Indonesia dengan bumbu kacang yang lezat',
        image: 'assets/image/menu.png',
        price: '18000',
        category: 'Salad',
        restaurantId: 1,
        stock: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
      MenuItem(
        id: 6,
        name: 'Pisang Goreng',
        description: 'Pisang goreng crispy dengan topping coklat',
        image: 'assets/image/menu.png',
        price: '12000',
        category: 'Dessert',
        restaurantId: 1,
        stock: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
