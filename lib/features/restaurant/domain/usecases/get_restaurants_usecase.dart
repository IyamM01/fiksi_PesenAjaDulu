import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantsUseCase {
  final RestaurantRepository repository;

  GetRestaurantsUseCase(this.repository);

  Future<List<Restaurant>> call() async {
    return await repository.getRestaurants();
  }
}
