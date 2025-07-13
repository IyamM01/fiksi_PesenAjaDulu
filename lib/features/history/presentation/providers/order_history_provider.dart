import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../order/data/services/order_api_service.dart';
import '../../../order/data/models/order_list_model/order_list_model.dart';

// Order History State
class OrderHistoryState {
  final List<OrderHistoryItem> orders;
  final bool isLoading;
  final String? errorMessage;

  const OrderHistoryState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OrderHistoryState copyWith({
    List<OrderHistoryItem>? orders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderHistoryState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Order History Item Model
class OrderHistoryItem {
  final String orderId;
  final String restaurantName;
  final String restaurantImage;
  final DateTime orderDate;
  final double totalAmount;
  final double onlineAmount;
  final double restaurantAmount;
  final String tableNumber;
  final String status; // pending, confirmed, completed, cancelled
  final List<OrderHistoryMenuItem> items;

  const OrderHistoryItem({
    required this.orderId,
    required this.restaurantName,
    required this.restaurantImage,
    required this.orderDate,
    required this.totalAmount,
    required this.onlineAmount,
    required this.restaurantAmount,
    required this.tableNumber,
    required this.status,
    required this.items,
  });
}

// Order History Menu Item Model
class OrderHistoryMenuItem {
  final String name;
  final String image;
  final int quantity;
  final double price;
  final double totalPrice;

  const OrderHistoryMenuItem({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });
}

// Order History Provider
class OrderHistoryNotifier extends StateNotifier<OrderHistoryState> {
  final OrderApiService _orderApiService;

  OrderHistoryNotifier(this._orderApiService)
    : super(const OrderHistoryState()) {
    loadOrdersFromApi(); // Load real data from API on initialization
  }

  /// Convert OrderListModel to OrderHistoryItem
  OrderHistoryItem _convertToOrderHistoryItem(OrderListModel order) {
    final items =
        order.orderItems?.map((item) {
          return OrderHistoryMenuItem(
            name: item.menu?.name ?? 'Unknown Item',
            image:
                'assets/image/menu.png', // Default image, you can enhance this
            quantity: item.quantity ?? 1,
            price: (item.price ?? 0).toDouble(),
            totalPrice: ((item.quantity ?? 1) * (item.price ?? 0)).toDouble(),
          );
        }).toList() ??
        [];

    return OrderHistoryItem(
      orderId: order.id ?? 'UNKNOWN',
      restaurantName:
          'Mang Engking Restaurant', // Default, you can enhance this with restaurant data
      restaurantImage: 'assets/image/mang_engking.png',
      orderDate: order.reservationTime ?? DateTime.now(),
      totalAmount: (order.amount ?? 0).toDouble(),
      onlineAmount: (order.advanceAmount ?? 0).toDouble(),
      restaurantAmount: (order.remainingAmount ?? 0).toDouble(),
      tableNumber: order.table?.number ?? 'Unknown',
      status: _mapOrderStatus(order.status),
      items: items,
    );
  }

  /// Map backend status to display status
  String _mapOrderStatus(String? backendStatus) {
    switch (backendStatus?.toLowerCase()) {
      case 'pending':
        return 'pending';
      case 'confirmed':
      case 'accepted':
        return 'confirmed';
      case 'completed':
      case 'delivered':
        return 'completed';
      case 'cancelled':
      case 'rejected':
        return 'cancelled';
      default:
        return 'pending';
    }
  }

  /// Load orders from API
  Future<void> loadOrdersFromApi() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final orders = await _orderApiService.fetchUserOrders();
      final orderHistoryItems = orders.map(_convertToOrderHistoryItem).toList();

      // Sort by most recent first
      orderHistoryItems.sort((a, b) => b.orderDate.compareTo(a.orderDate));

      state = state.copyWith(orders: orderHistoryItems, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Add new order to history (called after successful payment)
  void addOrder(OrderHistoryItem order) {
    final updatedOrders = [order, ...state.orders];
    state = state.copyWith(orders: updatedOrders);
  }

  // Filter orders by status
  List<OrderHistoryItem> getOrdersByStatus(String status) {
    return state.orders.where((order) => order.status == status).toList();
  }

  // Get order statistics
  Map<String, dynamic> getOrderStatistics() {
    final orders = state.orders;
    final completedOrders =
        orders.where((o) => o.status == 'completed').toList();
    final totalSpent = completedOrders.fold<double>(
      0,
      (sum, order) => sum + order.totalAmount,
    );

    return {
      'totalOrders': orders.length,
      'completedOrders': completedOrders.length,
      'pendingOrders': orders.where((o) => o.status == 'pending').length,
      'totalSpent': totalSpent,
      'averageOrderValue':
          completedOrders.isNotEmpty ? totalSpent / completedOrders.length : 0,
    };
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await loadOrdersFromApi();
  }
}

// API Service Provider
final orderApiServiceProvider = Provider<OrderApiService>((ref) {
  final dio = Dio();
  final authDataSource = AuthLocalDataSourceImpl();
  return OrderApiService(dio, authDataSource);
});

// Providers
final orderHistoryProvider =
    StateNotifierProvider<OrderHistoryNotifier, OrderHistoryState>((ref) {
      final orderApiService = ref.read(orderApiServiceProvider);
      return OrderHistoryNotifier(orderApiService);
    });

// Computed providers
final completedOrdersProvider = Provider<List<OrderHistoryItem>>((ref) {
  final orderHistory = ref.watch(orderHistoryProvider);
  return orderHistory.orders
      .where((order) => order.status == 'completed')
      .toList();
});

final pendingOrdersProvider = Provider<List<OrderHistoryItem>>((ref) {
  final orderHistory = ref.watch(orderHistoryProvider);
  return orderHistory.orders
      .where((order) => order.status == 'pending')
      .toList();
});

final orderStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final orderHistoryNotifier = ref.read(orderHistoryProvider.notifier);
  return orderHistoryNotifier.getOrderStatistics();
});
