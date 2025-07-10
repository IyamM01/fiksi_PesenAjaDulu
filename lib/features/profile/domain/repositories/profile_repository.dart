import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile(String userId);
  Future<UserProfile> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImage,
  });
}
