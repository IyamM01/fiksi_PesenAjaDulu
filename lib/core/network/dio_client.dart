import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '../config/environment.dart';
import '../exceptions/app_exceptions.dart';

class DioClient {
  static late Dio _dio;
  static late SharedPreferences _prefs;

  static Dio get dio => _dio;

  /// Initialize Dio client with base configuration
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10), // Reduced from 30s
        receiveTimeout: const Duration(seconds: 15), // Reduced from 30s
        sendTimeout: const Duration(seconds: 15), // Reduced from 30s
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.addAll([
      _AuthInterceptor(_prefs),
      _ErrorInterceptor(),
      _LogInterceptor(),
    ]);
  }

  /// Update base URL if needed
  static void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  /// Add or update token in headers
  static void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove token from headers
  static void removeToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Get current token from SharedPreferences
  static String? getToken() {
    return _prefs.getString(StorageKeys.accessToken);
  }

  /// Check if user is authenticated
  static bool isAuthenticated() {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }
}

/// Interceptor to automatically add authentication token to requests
class _AuthInterceptor extends Interceptor {
  final SharedPreferences _prefs;

  _AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add token to request if available
    final token = _prefs.getString(StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}

/// Interceptor to handle errors globally
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = NetworkException(message: 'Connection timeout');
        break;

      case DioExceptionType.badResponse:
        exception = _handleStatusCode(err);
        break;

      case DioExceptionType.cancel:
        exception = NetworkException(message: 'Request was cancelled');
        break;

      case DioExceptionType.connectionError:
        exception = NetworkException(message: 'No internet connection');
        break;

      case DioExceptionType.unknown:
        exception = NetworkException(message: 'Unknown error occurred');
        break;

      default:
        exception = NetworkException(message: 'Something went wrong');
        break;
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppException _handleStatusCode(DioException err) {
    final statusCode = err.response?.statusCode;
    final message = _extractErrorMessage(err.response?.data);

    switch (statusCode) {
      case 400:
        return ValidationException(message: message ?? 'Invalid request');
      case 401:
        return UnauthorizedException(message: message ?? 'Unauthorized access');
      case 403:
        return UnauthorizedException(message: message ?? 'Access forbidden');
      case 404:
        return NotFoundException(message: message ?? 'Resource not found');
      case 422:
        return ValidationException(message: message ?? 'Validation failed');
      case 500:
        return ServerException(message: message ?? 'Internal server error');
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message ?? 'Server is temporarily unavailable',
        );
      default:
        return NetworkException(message: message ?? 'Network error occurred');
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    try {
      if (data is Map<String, dynamic>) {
        // Try different common error message keys
        return data['message'] ??
            data['error'] ??
            data['detail'] ??
            data['msg'];
      }
      return data.toString();
    } catch (e) {
      return null;
    }
  }
}

/// Simple logging interceptor to replace pretty_dio_logger
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Environment.enableLogging) {
      debugPrint('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
      debugPrint('Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('Data: ${options.data}');
      }
      debugPrint('QueryParameters: ${options.queryParameters}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (Environment.enableLogging) {
      debugPrint(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      debugPrint('Data: ${response.data}');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (Environment.enableLogging) {
      debugPrint(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      debugPrint('Message: ${err.message}');
      if (err.response?.data != null) {
        debugPrint('Error Data: ${err.response?.data}');
      }
    }

    handler.next(err);
  }
}
