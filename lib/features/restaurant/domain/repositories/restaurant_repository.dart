import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantById(String id);
  Future<List<Restaurant>> searchRestaurants(String query);
  Future<List<Restaurant>> getNearbyRestaurants({
    double? latitude,
    double? longitude,
  });
  Future<List<Restaurant>> getRestaurantsByRating({double minRating = 0.0});
}
