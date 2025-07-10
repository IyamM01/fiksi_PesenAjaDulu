import '../entities/promotion.dart';

abstract class HomeRepository {
  Future<List<Promotion>> getActivePromotions();
  Future<List<Promotion>> getPromotionsByRestaurant(String restaurantId);
}
