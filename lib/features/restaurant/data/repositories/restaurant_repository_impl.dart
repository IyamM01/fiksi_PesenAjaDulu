import '../../domain/repositories/restaurant_repository.dart';
import '../../domain/entities/restaurant.dart';
import '../datasources/restaurant_remote_datasource.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDatasource _remoteDatasource;

  RestaurantRepositoryImpl({RestaurantRemoteDatasource? remoteDatasource})
    : _remoteDatasource = remoteDatasource ?? RestaurantRemoteDatasourceImpl();

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      return await _remoteDatasource.getRestaurants();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final restaurantId = int.tryParse(id);
      if (restaurantId == null) {
        throw ValidationException(message: 'Invalid restaurant ID');
      }
      return await _remoteDatasource.getRestaurantById(restaurantId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      if (query.trim().isEmpty) {
        return await _remoteDatasource.getRestaurants();
      }
      return await _remoteDatasource.searchRestaurants(query);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> getNearbyRestaurants({
    double? latitude,
    double? longitude,
  }) async {
    try {
      return await _remoteDatasource.getNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByRating({
    double minRating = 0.0,
  }) async {
    try {
      return await _remoteDatasource.getRestaurantsByRating(
        minRating: minRating,
      );
    } catch (e) {
      rethrow;
    }
  }
}
