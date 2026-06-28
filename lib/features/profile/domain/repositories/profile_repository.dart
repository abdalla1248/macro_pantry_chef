import '../entities/user_profile.dart';

/// Repository interface contract for loading and saving user profile details.
abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> saveProfile(UserProfile profile);
}
