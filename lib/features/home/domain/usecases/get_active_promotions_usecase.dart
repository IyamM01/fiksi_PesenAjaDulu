import '../entities/promotion.dart';
import '../repositories/home_repository.dart';

class GetActivePromotionsUseCase {
  final HomeRepository repository;

  GetActivePromotionsUseCase(this.repository);

  Future<List<Promotion>> call() async {
    return await repository.getActivePromotions();
  }
}
