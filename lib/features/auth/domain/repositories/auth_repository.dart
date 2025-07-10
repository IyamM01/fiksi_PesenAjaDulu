import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> signUp({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });

  Future<void> logout();

  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<void> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImage,
  });
}
