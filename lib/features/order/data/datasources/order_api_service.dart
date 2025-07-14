import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/order_list_model/order_list_model.dart';

class OrderApiService {
  final Dio _dio;
  final AuthLocalDataSource _authDataSource;

  OrderApiService(this._dio, this._authDataSource);

  /// Fetch all orders for the authenticated user
  Future<List<OrderListModel>> fetchUserOrders() async {
    try {
      final token = await _authDataSource.getToken();
      
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.orderEndpoint}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle different response formats
        if (responseData is Map<String, dynamic>) {
          // If response is wrapped in a data field
          if (responseData.containsKey('data')) {
            final dataList = responseData['data'] as List;
            return dataList
                .map((orderJson) => OrderListModel.fromJson(orderJson as Map<String, dynamic>))
                .toList();
          } else {
            // If response is a single order wrapped in an object
            return [OrderListModel.fromJson(responseData)];
          }
        } else if (responseData is List) {
          // If response is directly a list of orders
          return responseData
              .map((orderJson) => OrderListModel.fromJson(orderJson as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch orders: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (e.response?.statusCode == 404) {
        // Return empty list if no orders found
        return [];
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Fetch a specific order by ID
  Future<OrderListModel?> fetchOrderById(String orderId) async {
    try {
      final token = await _authDataSource.getToken();
      
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.orderEndpoint}/$orderId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData is Map<String, dynamic>) {
          // If response is wrapped in a data field
          if (responseData.containsKey('data')) {
            return OrderListModel.fromJson(responseData['data'] as Map<String, dynamic>);
          } else {
            // If response is directly the order object
            return OrderListModel.fromJson(responseData);
          }
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (e.response?.statusCode == 404) {
        return null; // Order not found
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }
}
