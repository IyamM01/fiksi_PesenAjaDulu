import 'package:flutter_fiksi/features/restaurant/domain/entities/restaurant.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fiksi/core/di/dependency_injection.dart';
import 'package:flutter_fiksi/core/constants/app_constants.dart';
import 'package:flutter_fiksi/core/exceptions/app_exceptions.dart';

abstract class RestaurantRemoteDatasource {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantById(int id);
  Future<List<Restaurant>> searchRestaurants(String query);
  Future<List<Restaurant>> getNearbyRestaurants({
    double? latitude,
    double? longitude,
  });
  Future<List<Restaurant>> getRestaurantsByRating({double minRating = 0.0});
}

class RestaurantRemoteDatasourceImpl implements RestaurantRemoteDatasource {
  final Dio _dio;

  RestaurantRemoteDatasourceImpl({Dio? dio}) : _dio = dio ?? sl<Dio>();

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await _dio.get(ApiConstants.restaurantEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> restaurantData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['restaurants'] ?? [];

        return restaurantData.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch restaurants');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return mock data for testing when server is not available
        return _getMockRestaurants();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch restaurants: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred while fetching restaurants',
      );
    }
  }

  @override
  Future<Restaurant> getRestaurantById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.restaurantEndpoint}/$id');

      if (response.statusCode == 200 && response.data != null) {
        return Restaurant.fromJson(response.data);
      } else {
        throw ServerException(message: 'Failed to fetch restaurant details');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return mock data
        final mockRestaurants = _getMockRestaurants();
        final restaurant = mockRestaurants.firstWhere(
          (r) => r.id == id,
          orElse:
              () => throw NotFoundException(message: 'Restaurant not found'),
        );
        return restaurant;
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch restaurant details: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message:
            'An unexpected error occurred while fetching restaurant details',
      );
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.restaurantEndpoint}?search=$query',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> restaurantData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['restaurants'] ?? [];

        return restaurantData.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to search restaurants');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return filtered mock data
        return _getMockRestaurants().where((restaurant) {
          final name = restaurant.name?.toLowerCase() ?? '';
          final description = restaurant.description?.toLowerCase() ?? '';
          final address = restaurant.address?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();

          return name.contains(searchQuery) ||
              description.contains(searchQuery) ||
              address.contains(searchQuery);
        }).toList();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to search restaurants: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred while searching restaurants',
      );
    }
  }

  @override
  Future<List<Restaurant>> getNearbyRestaurants({
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.restaurantEndpoint}/nearby',
        queryParameters: {
          if (latitude != null) 'latitude': latitude,
          if (longitude != null) 'longitude': longitude,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> restaurantData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['restaurants'] ?? [];

        return restaurantData.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch nearby restaurants');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return mock data (in real app, you'd filter by location)
        return _getMockRestaurants();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch nearby restaurants: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message:
            'An unexpected error occurred while fetching nearby restaurants',
      );
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByRating({
    double minRating = 0.0,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.restaurantEndpoint}?min_rating=$minRating',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> restaurantData =
            response.data is List
                ? response.data
                : response.data['data'] ?? response.data['restaurants'] ?? [];

        return restaurantData.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'Failed to fetch restaurants by rating');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout) {
        // Return filtered mock data
        return _getMockRestaurants()
            .where((restaurant) => (restaurant.rating ?? 0.0) >= minRating)
            .toList();
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(
        message: 'Failed to fetch restaurants by rating: ${e.message}',
      );
    } catch (e) {
      throw NetworkException(
        message:
            'An unexpected error occurred while fetching restaurants by rating',
      );
    }
  }

  // Mock data for testing when API is not available
  List<Restaurant> _getMockRestaurants() {
    return [
      Restaurant(
        id: 1,
        name: 'Mang Engking',
        description:
            'Authentic Indonesian cuisine with fresh seafood and traditional dishes. Experience the best of Indonesian flavors in a cozy atmosphere.',
        image: 'assets/image/mang_engking.png',
        address: 'Jl. Sudirman No. 123, Jakarta Pusat',
        rating: 4.5,
        phoneNumber: '+62-21-1234-5678',
        isOpen: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Restaurant(
        id: 2,
        name: 'Warung Padang Sederhana',
        description:
            'Traditional Padang cuisine with spicy and flavorful dishes. Try our famous rendang and other Minangkabau specialties.',
        image: 'assets/image/menu.png',
        address: 'Jl. Kemang Raya No. 45, Jakarta Selatan',
        rating: 4.2,
        phoneNumber: '+62-21-2345-6789',
        isOpen: true,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
      Restaurant(
        id: 3,
        name: 'Soto Betawi Haji Mamat',
        description:
            'The best Soto Betawi in town. Rich coconut milk broth with tender beef and traditional spices.',
        image: 'assets/image/menu.png',
        address: 'Jl. Menteng Dalam No. 67, Jakarta Pusat',
        rating: 4.7,
        phoneNumber: '+62-21-3456-7890',
        isOpen: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      Restaurant(
        id: 4,
        name: 'Bakso Solo Pak Kumis',
        description:
            'Delicious meatball soup with homemade noodles and rich broth. A local favorite for comfort food.',
        image: 'assets/image/menu.png',
        address: 'Jl. Fatmawati No. 89, Jakarta Selatan',
        rating: 4.0,
        phoneNumber: '+62-21-4567-8901',
        isOpen: true,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      Restaurant(
        id: 5,
        name: 'Ayam Geprek Bensu',
        description:
            'Crispy fried chicken with spicy sambal. Perfect for those who love heat and flavor.',
        image: 'assets/image/menu.png',
        address: 'Jl. Cipete Raya No. 12, Jakarta Selatan',
        rating: 3.8,
        phoneNumber: '+62-21-5678-9012',
        isOpen: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      Restaurant(
        id: 6,
        name: 'Es Krim Ragusa',
        description:
            'Premium ice cream parlor with unique Indonesian flavors. Try our avocado and jackfruit ice cream.',
        image: 'assets/image/menu.png',
        address: 'Jl. Blok M Square No. 34, Jakarta Selatan',
        rating: 4.3,
        phoneNumber: '+62-21-6789-0123',
        isOpen: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
