import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../domain/entities/order_item.dart';
import '../../../menu/domain/entities/menu_item.dart';
import '../../data/models/request_order_model/request_order_model.dart';
import '../../data/models/request_order_model/order_item.dart'
    as request_order_item;
import '../../../history/presentation/providers/order_history_provider.dart';

// ============================================================================
// 📱 ORDER STATE - Cart and Order Management
// ============================================================================

/// Order state for managing current order/cart
class OrderState {
  final List<OrderItem> items;
  final String? restaurantId;
  final String? restaurantName;
  final String? selectedTableId;
  final DateTime? reservationTime;
  final bool isLoading;
  final String? errorMessage;

  const OrderState({
    this.items = const [],
    this.restaurantId,
    this.restaurantName,
    this.selectedTableId,
    this.reservationTime,
    this.isLoading = false,
    this.errorMessage,
  });

  OrderState copyWith({
    List<OrderItem>? items,
    String? restaurantId,
    String? restaurantName,
    String? selectedTableId,
    DateTime? reservationTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderState(
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      selectedTableId: selectedTableId ?? this.selectedTableId,
      reservationTime: reservationTime ?? this.reservationTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get tax {
    return subtotal * 0.1; // 10% tax
  }

  double get total {
    return subtotal + tax;
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

/// Order notifier for cart operations
class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier() : super(const OrderState());

  /// Get authentication token for API requests
  Future<String?> _getAuthToken() async {
    try {
      // Get token from auth local datasource
      final authLocalDataSource = AuthLocalDataSourceImpl();
      return await authLocalDataSource.getToken();
    } catch (e) {
      return null;
    }
  }

  /// Get authenticated user ID
  int? _getUserId() {
    // TODO: Get from auth state
    // For now, return hardcoded value or null if not authenticated
    return 1;
  }

  /// Set restaurant context when starting an order
  void setRestaurant(String restaurantId, String restaurantName) {
    state = state.copyWith(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      items: [], // Clear previous items when switching restaurants
    );
  }

  /// Add item to cart
  void addItem(MenuItem menuItem, {int quantity = 1, String? notes}) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.menuItemId == menuItem.id.toString(),
    );

    List<OrderItem> updatedItems;

    if (existingItemIndex >= 0) {
      // Update quantity if item already exists
      final existingItem = state.items[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        notes: notes ?? existingItem.notes,
      );
      updatedItems = List.from(state.items);
      updatedItems[existingItemIndex] = updatedItem;
    } else {
      // Add new item
      final newItem = OrderItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        menuItemId: menuItem.id.toString(),
        menuItemName: menuItem.name ?? 'Unknown Item',
        menuItemImage: menuItem.image ?? '',
        price: menuItem.priceAsDouble,
        quantity: quantity,
        notes: notes,
      );
      updatedItems = [...state.items, newItem];
    }

    state = state.copyWith(items: updatedItems);
  }

  /// Remove item from cart
  void removeItem(String itemId) {
    final updatedItems =
        state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Decrease quantity of a menu item by 1
  void decreaseQuantity(String menuItemId) {
    final existingItemIndex = state.items.indexWhere(
      (item) => item.menuItemId == menuItemId,
    );

    if (existingItemIndex >= 0) {
      final existingItem = state.items[existingItemIndex];
      if (existingItem.quantity > 1) {
        // Decrease quantity by 1
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
        );
        final updatedItems = List<OrderItem>.from(state.items);
        updatedItems[existingItemIndex] = updatedItem;
        state = state.copyWith(items: updatedItems);
      } else {
        // Remove item if quantity becomes 0
        final updatedItems = List<OrderItem>.from(state.items);
        updatedItems.removeAt(existingItemIndex);
        state = state.copyWith(items: updatedItems);
      }
    }
  }

  /// Remove all items of a specific menu item from cart
  void removeMenuItemCompletely(String menuItemId) {
    final updatedItems = state.items.where(
      (item) => item.menuItemId != menuItemId,
    ).toList();
    state = state.copyWith(items: updatedItems);
  }

  /// Update item quantity
  void updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems =
        state.items.map((item) {
          if (item.id == itemId) {
            return item.copyWith(quantity: quantity);
          }
          return item;
        }).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// Set table and reservation time
  void setTableReservation(String tableId, DateTime reservationTime) {
    state = state.copyWith(
      selectedTableId: tableId,
      reservationTime: reservationTime,
    );
  }

  /// Update table selection and reservation time
  void updateTableSelection(String tableId, DateTime reservationTime) {
    state = state.copyWith(
      selectedTableId: tableId,
      reservationTime: reservationTime,
    );
  }

  /// Clear cart
  void clearCart() {
    state = state.copyWith(
      items: [],
      restaurantId: null,
      restaurantName: null,
      selectedTableId: null,
      reservationTime: null,
      errorMessage: null,
    );
  }

  /// Create order (placeholder for API call)
  Future<Map<String, String>?> createOrder() async {
    if (state.items.isEmpty) {
      state = state.copyWith(errorMessage: 'Cart is empty');
      return null;
    }

    if (state.restaurantId == null || state.selectedTableId == null) {
      state = state.copyWith(
        errorMessage: 'Missing restaurant or table information',
      );
      return null;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Generate customer-friendly order number
      final now = DateTime.now();
      final orderNumber =
          'ORD-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch % 1000000}';
      final orderId = 'order_${now.millisecondsSinceEpoch}';

      // Prepare order data for API using RequestOrderModel
      final requestOrderItems =
          state.items
              .map(
                (item) => request_order_item.OrderItem(
                  menuId: int.tryParse(item.menuItemId),
                  quantity: item.quantity,
                  price: item.price.toInt(),
                ),
              )
              .toList();

      final requestOrder = RequestOrderModel(
        userId: _getUserId() ?? 1, // Get from auth state or fallback
        tableId: int.tryParse(state.selectedTableId ?? '0'),
        amount: (state.total / 2).toInt(), // 50% for online payment
        reservationTime: state.reservationTime?.toIso8601String(),
        orderItems: requestOrderItems,
      );

      // Convert to JSON for API call
      final orderData = requestOrder.toJson();

      // Get authentication token
      final token = await _getAuthToken();

      // API call to create order using orderStoreEndpoint
      try {
        final dio = Dio();
        final response = await dio.post(
          '${ApiConstants.baseUrl}${ApiConstants.orderStoreEndpoint}',
          data: orderData,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = response.data;

          // Extract response data with proper null checks
          final snapUrl =
              responseData is Map ? responseData['snap_url']?.toString() : null;
          final backendOrderId =
              responseData is Map ? responseData['order_id']?.toString() : null;
          final backendOrderNumber =
              responseData is Map
                  ? responseData['order_number']?.toString()
                  : null;

          state = state.copyWith(isLoading: false);

          // Return order details for navigation
          return {
            'orderId': backendOrderId ?? orderId,
            'orderNumber': backendOrderNumber ?? orderNumber,
            'snapUrl':
                snapUrl ??
                'https://app.sandbox.midtrans.com/snap/v3/redirection/$orderId',
            'onlineAmount': (state.total / 2).toInt().toString(),
            'restaurantAmount': (state.total / 2).toInt().toString(),
            'totalAmount': state.total.toInt().toString(),
          };
        } else {
          throw Exception('Failed to create order: ${response.statusMessage}');
        }
      } on DioException catch (e) {
        String errorMessage = 'Failed to create order';

        if (e.response?.data != null) {
          final errorData = e.response!.data;
          if (errorData is Map && errorData['message'] != null) {
            errorMessage = errorData['message'].toString();
          } else if (errorData is String) {
            errorMessage = errorData;
          }
        } else if (e.message != null) {
          errorMessage = e.message!;
        }

        // Debug logging (remove in production)
        // print('DioException: $e');
        // print('Response data: ${e.response?.data}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create order: $e',
      );
      return null;
    }
  }

  /// Handle successful payment completion
  void completePayment() {
    // Clear the cart after successful payment
    clearCart();
  }

  /// Handle successful payment completion with order details
  void completePaymentWithOrderDetails(
    Map<String, dynamic> orderDetails,
    WidgetRef ref,
  ) {
    // Add order to history
    try {
      final orderHistoryNotifier = ref.read(orderHistoryProvider.notifier);

      // Create OrderHistoryItem from the current order state and order details
      final orderHistoryItem = OrderHistoryItem(
        orderId:
            orderDetails['orderNumber'] ?? orderDetails['orderId'] ?? 'UNKNOWN',
        restaurantName: state.restaurantName ?? 'Mang Engking Restaurant',
        restaurantImage: 'assets/image/mang_engking.png',
        orderDate: DateTime.now(),
        totalAmount: state.total,
        onlineAmount: state.total / 2, // 50% online payment
        restaurantAmount: state.total / 2, // 50% restaurant payment
        tableNumber: state.selectedTableId ?? 'Unknown',
        status: 'pending', // New orders start as pending
        items:
            state.items
                .map(
                  (item) => OrderHistoryMenuItem(
                    name: item.menuItemName,
                    image:
                        item.menuItemImage.isNotEmpty
                            ? item.menuItemImage
                            : 'assets/image/menu.png',
                    quantity: item.quantity,
                    price: item.price,
                    totalPrice: item.price * item.quantity,
                  ),
                )
                .toList(),
      );

      // Add to order history
      orderHistoryNotifier.addOrder(orderHistoryItem);
    } catch (e) {
      // If adding to history fails, just log it but don't block the payment completion
      print('Failed to add order to history: $e');
    }

    // Clear the cart after successful payment
    clearCart();
  }
}

// ============================================================================
// 🏗️ PROVIDERS - Order Management
// ============================================================================

/// Main order provider
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier();
});

/// Individual providers for specific parts of the order state
final orderItemsProvider = Provider<List<OrderItem>>((ref) {
  return ref.watch(orderProvider).items;
});

final orderSubtotalProvider = Provider<double>((ref) {
  return ref.watch(orderProvider).subtotal;
});

final orderTaxProvider = Provider<double>((ref) {
  return ref.watch(orderProvider).tax;
});

final orderTotalProvider = Provider<double>((ref) {
  return ref.watch(orderProvider).total;
});

final orderTotalItemsProvider = Provider<int>((ref) {
  return ref.watch(orderProvider).totalItems;
});

final orderRestaurantProvider = Provider<String?>((ref) {
  return ref.watch(orderProvider).restaurantName;
});

final orderLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orderProvider).isLoading;
});

final orderErrorProvider = Provider<String?>((ref) {
  return ref.watch(orderProvider).errorMessage;
});
