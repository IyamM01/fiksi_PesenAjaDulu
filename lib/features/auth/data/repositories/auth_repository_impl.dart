import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/exceptions/app_exceptions.dart';

/// Implementation of AuthRepository
/// This coordinates between remote and local data sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
    AuthLocalDataSource? localDataSource,
  }) : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSourceImpl(),
       _localDataSource = localDataSource ?? AuthLocalDataSourceImpl();

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      // 1. Call remote data source
      final loginData = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // 2. Extract token (no user data expected from login response)
      final token =
          loginData['token'] as String? ?? loginData['access_token'] as String?;
      final refreshToken = loginData['refresh_token'] as String?;

      if (token == null) {
        throw ServerException(message: 'No access token received');
      }

      // 3. Save tokens locally
      await _localDataSource.saveToken(token);
      if (refreshToken != null) {
        await _localDataSource.saveRefreshToken(refreshToken);
      }

      // 4. Set token in DioClient for future requests
      DioClient.setToken(token);

      // 5. Fetch user data from server using the token
      User user;
      try {
        final userData = await _remoteDataSource.getCurrentUser();
        user = User.fromJson(userData);
      } catch (e) {
        // If fetching user data fails, create a minimal user object
        // The user data can be fetched later when needed
        user = User(
          id: '',
          name: '',
          email: email, // Use the login email
          phoneNumber: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }

      await _localDataSource.saveUser(user);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // 1. Call remote data source
      final signUpData = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phoneNumber ?? '',
      );

      // 2. Extract user data (signup might not return token immediately)
      final userData =
          signUpData['user'] as Map<String, dynamic>? ?? signUpData;
      final user = User.fromJson(userData);

      // 3. If token is provided, save it
      final token = signUpData['access_token'] as String?;
      if (token != null) {
        await _localDataSource.saveToken(token);
        DioClient.setToken(token);
        await _localDataSource.saveUser(user);
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // 1. Try to logout from server (optional - might fail if token expired)
      try {
        await _remoteDataSource.logout();
      } catch (e) {
        // Server logout failed, but continue with local cleanup
        print('Server logout failed: $e');
      }

      // 2. Always clean up local data
      await _localDataSource.clearAllData();

      // 3. Remove token from DioClient
      DioClient.removeToken();
    } catch (e) {
      // Even if everything fails, ensure local cleanup
      await _localDataSource.clearAllData();
      DioClient.removeToken();
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // 1. First try to get cached user
      final cachedUser = await _localDataSource.getUser();

      // 2. Check if we have a valid token
      final token = await _localDataSource.getToken();
      if (token == null) {
        return null;
      }

      // 3. If no cached user or we want fresh data, fetch from server
      if (cachedUser == null) {
        try {
          final userData = await _remoteDataSource.getCurrentUser();
          final user = User.fromJson(userData);

          // Cache the fresh user data
          await _localDataSource.saveUser(user);
          return user;
        } catch (e) {
          // If server call fails, return cached user (if any)
          return cachedUser;
        }
      }

      return cachedUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await _localDataSource.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImage,
  }) async {
    try {
      // Implementation depends on your API
      // This is a placeholder for the update profile functionality
      throw UnimplementedError('Update profile not implemented yet');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    await _localDataSource.saveToken(token);
    DioClient.setToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await _localDataSource.getToken();
  }

  /// Additional helper methods for better token management
  Future<void> refreshUserToken() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        throw UnauthorizedException(message: 'No refresh token available');
      }

      final tokenData = await _remoteDataSource.refreshToken(refreshToken);
      final newAccessToken = tokenData['access_token'] as String;
      final newRefreshToken = tokenData['refresh_token'] as String?;

      await _localDataSource.saveToken(newAccessToken);
      if (newRefreshToken != null) {
        await _localDataSource.saveRefreshToken(newRefreshToken);
      }

      DioClient.setToken(newAccessToken);
    } catch (e) {
      // If refresh fails, user needs to login again
      await logout();
      rethrow;
    }
  }
}
