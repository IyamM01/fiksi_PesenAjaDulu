import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../../data/datasources/restaurant_remote_datasource.dart';
import '../../domain/entities/restaurant.dart';
import '../../../../core/exceptions/app_exceptions.dart';

// ============================================================================
// 🏗️ PROVIDERS - Dependency Injection with Riverpod
// ============================================================================

/// Remote data source provider
final restaurantRemoteDataSourceProvider = Provider<RestaurantRemoteDatasource>(
  (ref) {
    return RestaurantRemoteDatasourceImpl();
  },
);

/// Repository provider
final restaurantRepositoryProvider = Provider<RestaurantRepositoryImpl>((ref) {
  return RestaurantRepositoryImpl(
    remoteDatasource: ref.read(restaurantRemoteDataSourceProvider),
  );
});

// ============================================================================
// 📱 RESTAURANT STATE - Simple State Management
// ============================================================================

/// Restaurant state
class RestaurantState {
  final List<Restaurant> restaurants;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final double minRating;

  const RestaurantState({
    this.restaurants = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.minRating = 0.0,
  });

  RestaurantState copyWith({
    List<Restaurant>? restaurants,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    double? minRating,
  }) {
    return RestaurantState(
      restaurants: restaurants ?? this.restaurants,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      minRating: minRating ?? this.minRating,
    );
  }
}

/// Restaurant state notifier
class RestaurantNotifier extends Notifier<RestaurantState> {
  late RestaurantRepositoryImpl _restaurantRepository;

  @override
  RestaurantState build() {
    _restaurantRepository = ref.read(restaurantRepositoryProvider);
    return const RestaurantState();
  }

  /// Load all restaurants
  Future<void> loadRestaurants() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final restaurants = await _restaurantRepository.getRestaurants();

      state = state.copyWith(restaurants: restaurants, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load restaurants',
      );
    }
  }

  /// Search restaurants
  Future<void> searchRestaurants(String query) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        searchQuery: query,
      );

      final restaurants = await _restaurantRepository.searchRestaurants(query);

      state = state.copyWith(restaurants: restaurants, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to search restaurants',
      );
    }
  }

  /// Load nearby restaurants
  Future<void> loadNearbyRestaurants({
    double? latitude,
    double? longitude,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final restaurants = await _restaurantRepository.getNearbyRestaurants(
        latitude: latitude,
        longitude: longitude,
      );

      state = state.copyWith(restaurants: restaurants, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load nearby restaurants',
      );
    }
  }

  /// Load restaurants by rating
  Future<void> loadRestaurantsByRating(double minRating) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        minRating: minRating,
      );

      final restaurants = await _restaurantRepository.getRestaurantsByRating(
        minRating: minRating,
      );

      state = state.copyWith(restaurants: restaurants, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load restaurants by rating',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset to initial state
  void reset() {
    state = const RestaurantState();
  }
}

/// Restaurant state provider
final restaurantProvider =
    NotifierProvider<RestaurantNotifier, RestaurantState>(() {
      return RestaurantNotifier();
    });

// ============================================================================
// 🎯 CONVENIENT DERIVED PROVIDERS
// ============================================================================

/// Get restaurants
final restaurantsProvider = Provider<List<Restaurant>>((ref) {
  return ref.watch(restaurantProvider).restaurants;
});

/// Check if restaurants are loading
final restaurantLoadingProvider = Provider<bool>((ref) {
  return ref.watch(restaurantProvider).isLoading;
});

/// Get restaurant error message
final restaurantErrorProvider = Provider<String?>((ref) {
  return ref.watch(restaurantProvider).errorMessage;
});

/// Get search query
final restaurantSearchQueryProvider = Provider<String>((ref) {
  return ref.watch(restaurantProvider).searchQuery;
});

/// Get minimum rating filter
final restaurantMinRatingProvider = Provider<double>((ref) {
  return ref.watch(restaurantProvider).minRating;
});

/// Get open restaurants only
final openRestaurantsProvider = Provider<List<Restaurant>>((ref) {
  final restaurants = ref.watch(restaurantsProvider);
  return restaurants.where((restaurant) => restaurant.isAvailable).toList();
});

/// Get restaurants by rating (high to low)
final restaurantsByRatingProvider = Provider<List<Restaurant>>((ref) {
  final restaurants = ref.watch(restaurantsProvider);
  final sortedRestaurants = List<Restaurant>.from(restaurants);
  sortedRestaurants.sort(
    (a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0),
  );
  return sortedRestaurants;
});

/// Get restaurant count
final restaurantCountProvider = Provider<int>((ref) {
  return ref.watch(restaurantsProvider).length;
});

// ============================================================================
// 🏪 INDIVIDUAL RESTAURANT PROVIDER
// ============================================================================

/// Provider for fetching a single restaurant by ID
final restaurantByIdProvider = FutureProvider.family<Restaurant, String>((
  ref,
  id,
) async {
  final repository = ref.read(restaurantRepositoryProvider);
  return await repository.getRestaurantById(id);
});
