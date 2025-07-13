import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/menu_repository_impl.dart';
import '../../data/datasources/menu_remote_datasource.dart';
import '../../domain/entities/menu_item.dart';
import '../../../../core/exceptions/app_exceptions.dart';

// ============================================================================
// 🏗️ PROVIDERS - Dependency Injection with Riverpod
// ============================================================================

/// Remote data source provider
final menuRemoteDataSourceProvider = Provider<MenuRemoteDatasource>((ref) {
  return MenuRemoteDatasourceImpl();
});

/// Repository provider
final menuRepositoryProvider = Provider<MenuRepositoryImpl>((ref) {
  return MenuRepositoryImpl(
    remoteDatasource: ref.read(menuRemoteDataSourceProvider),
  );
});

// ============================================================================
// 📱 MENU STATE - Simple State Management
// ============================================================================

/// Menu state
class MenuState {
  final List<MenuItem> menuItems;
  final bool isLoading;
  final String? errorMessage;
  final String selectedCategory;

  const MenuState({
    this.menuItems = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCategory = 'All',
  });

  MenuState copyWith({
    List<MenuItem>? menuItems,
    bool? isLoading,
    String? errorMessage,
    String? selectedCategory,
  }) {
    return MenuState(
      menuItems: menuItems ?? this.menuItems,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// Menu state notifier
class MenuNotifier extends Notifier<MenuState> {
  late MenuRepositoryImpl _menuRepository;

  @override
  MenuState build() {
    _menuRepository = ref.read(menuRepositoryProvider);
    return const MenuState();
  }

  /// Load all menu items
  Future<void> loadMenuItems() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final menuItems = await _menuRepository.getMenuItems();

      state = state.copyWith(menuItems: menuItems, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load menu items',
      );
    }
  }

  /// Load menu items by restaurant
  Future<void> loadMenuItemsByRestaurant(String restaurantId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final menuItems = await _menuRepository.getMenuItemsByRestaurant(
        restaurantId,
      );

      state = state.copyWith(menuItems: menuItems, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load restaurant menu',
      );
    }
  }

  /// Load menu items by category
  Future<void> loadMenuItemsByCategory(String category) async {
    try {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        selectedCategory: category,
      );

      final menuItems = await _menuRepository.getMenuItemsByCategory(category);

      state = state.copyWith(menuItems: menuItems, isLoading: false);
    } on NetworkException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on ServerException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load menu by category',
      );
    }
  }

  /// Search menu items
  Future<void> searchMenuItems(String query) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final menuItems = await _menuRepository.searchMenuItems(query);

      state = state.copyWith(menuItems: menuItems, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to search menu items',
      );
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Reset to initial state
  void reset() {
    state = const MenuState();
  }
}

/// Menu state provider
final menuProvider = NotifierProvider<MenuNotifier, MenuState>(() {
  return MenuNotifier();
});

// ============================================================================
// 🎯 CONVENIENT DERIVED PROVIDERS
// ============================================================================

/// Get menu items
final menuItemsProvider = Provider<List<MenuItem>>((ref) {
  return ref.watch(menuProvider).menuItems;
});

/// Check if menu is loading
final menuLoadingProvider = Provider<bool>((ref) {
  return ref.watch(menuProvider).isLoading;
});

/// Get menu error message
final menuErrorProvider = Provider<String?>((ref) {
  return ref.watch(menuProvider).errorMessage;
});

/// Get selected category
final selectedCategoryProvider = Provider<String>((ref) {
  return ref.watch(menuProvider).selectedCategory;
});

/// Get available categories
final availableCategoriesProvider = Provider<List<String>>((ref) {
  final menuItems = ref.watch(menuItemsProvider);
  final categories =
      menuItems.map((item) => item.category ?? 'Other').toSet().toList();

  categories.sort();
  return ['All', ...categories];
});

/// Get filtered menu items by category
final filteredMenuItemsProvider = Provider<List<MenuItem>>((ref) {
  final menuItems = ref.watch(menuItemsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == 'All') {
    return menuItems;
  }

  return menuItems.where((item) => item.category == selectedCategory).toList();
});
