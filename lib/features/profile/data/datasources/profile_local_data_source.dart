import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_profile.dart';

/// Local data source to persist [UserProfile] locally in [SharedPreferences].
class ProfileLocalDataSource {
  ProfileLocalDataSource({required this.prefs});

  final SharedPreferences prefs;
  static const _key = 'user_profile';

  /// Reads profile from SharedPreferences, falling back to default values if not found.
  Future<UserProfile> getProfile() async {
    final raw = prefs.getString(_key);
    if (raw == null) {
      return const UserProfile();
    }
    try {
      return UserProfile.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const UserProfile();
    }
  }

  /// Writes profile to SharedPreferences.
  Future<void> saveProfile(UserProfile profile) async {
    await prefs.setString(_key, json.encode(profile.toJson()));
  }
}
