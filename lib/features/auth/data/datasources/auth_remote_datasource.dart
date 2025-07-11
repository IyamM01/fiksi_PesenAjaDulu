import 'package:dio/dio.dart';
import 'package:flutter_fiksi/core/di/dependency_injection.dart';
import 'package:flutter_fiksi/core/constants/app_constants.dart';
import 'package:flutter_fiksi/core/exceptions/app_exceptions.dart';

/// Abstract contract for remote authentication data source
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<Map<String, dynamic>> getCurrentUser();
  Future<void> logout();
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
}

/// Implementation of remote authentication data source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({Dio? dio}) : _dio = dio ?? sl<Dio>();

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Invalid response from server');
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(message: 'Login failed: ${e.message}');
    } catch (e) {
      print(e.toString());
      throw NetworkException(
        message: 'An unexpected error occurred during login',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.signupEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Registration failed');
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(message: 'Registration failed: ${e.message}');
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred during registration',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/user');

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Failed to fetch user data');
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(message: 'Failed to get user: ${e.message}');
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred while fetching user',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } on DioException catch (e) {
      // Even if logout fails on server, we consider it successful
      // The repository will handle token cleanup
      if (e.response?.statusCode == 401) {
        // Token already invalid, logout successful
        return;
      }

      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(message: 'Logout failed: ${e.message}');
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred during logout',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException(message: 'Token refresh failed');
      }
    } on DioException catch (e) {
      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException(message: 'Token refresh failed: ${e.message}');
    } catch (e) {
      throw NetworkException(
        message: 'An unexpected error occurred during token refresh',
      );
    }
  }
}
