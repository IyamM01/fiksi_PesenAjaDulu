import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../domain/entities/user.dart';
import 'dart:convert';

/// Abstract contract for local authentication data source
abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearAllData();
  Future<void> removeToken();
}

/// Implementation of local authentication data source using SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl({SharedPreferences? prefs})
    : _prefs = prefs ?? sl<SharedPreferences>();

  @override
  Future<void> saveToken(String token) async {
    try {
      final success = await _prefs.setString(StorageKeys.accessToken, token);
      if (!success) {
        throw CacheException(message: 'Failed to save access token');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save access token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return _prefs.getString(StorageKeys.accessToken);
    } catch (e) {
      throw CacheException(message: 'Failed to get access token: $e');
    }
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      final success = await _prefs.setString(
        StorageKeys.refreshToken,
        refreshToken,
      );
      if (!success) {
        throw CacheException(message: 'Failed to save refresh token');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save refresh token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return _prefs.getString(StorageKeys.refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to get refresh token: $e');
    }
  }

  @override
  Future<void> saveUser(User user) async {
    try {
      // Convert user to JSON for storage
      final userMap = {
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'phoneNumber': user.phoneNumber,
        'createdAt': user.createdAt.toIso8601String(),
        'updatedAt': user.updatedAt.toIso8601String(),
      };

      final userJson = jsonEncode(userMap);
      final success = await _prefs.setString(StorageKeys.userProfile, userJson);
      if (!success) {
        throw CacheException(message: 'Failed to save user profile');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save user profile: $e');
    }
  }

  @override
  Future<User?> getUser() async {
    try {
      final userJson = _prefs.getString(StorageKeys.userProfile);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User(
        id: userMap['id'] as String,
        email: userMap['email'] as String,
        name: userMap['name'] as String,
        phoneNumber: userMap['phoneNumber'] as String?,
        createdAt: DateTime.parse(userMap['createdAt'] as String),
        updatedAt: DateTime.parse(userMap['updatedAt'] as String),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to get user profile: $e');
    }
  }

  @override
  Future<void> clearAllData() async {
    try {
      await Future.wait([
        _prefs.remove(StorageKeys.accessToken),
        _prefs.remove(StorageKeys.refreshToken),
        _prefs.remove(StorageKeys.userProfile),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear local data: $e');
    }
  }

  @override
  Future<void> removeToken() async {
    try {
      await _prefs.remove(StorageKeys.accessToken);
    } catch (e) {
      throw CacheException(message: 'Failed to remove token: $e');
    }
  }
}
