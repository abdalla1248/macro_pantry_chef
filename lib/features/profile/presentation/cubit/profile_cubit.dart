import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../pantry/data/models/macro_targets.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

/// Cubit managing loading, updating, and saving user profile details.
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.repository})
      : super(const ProfileState()) {
    loadProfile();
  }

  final ProfileRepository repository;

  /// Loads the profile from local storage.
  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profile = await repository.getProfile();
      emit(state.copyWith(profile: profile, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _updateProfile(UserProfile newProfile) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await repository.saveProfile(newProfile);
      emit(state.copyWith(profile: newProfile, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Updates user's name.
  Future<void> updateName(String name) async {
    final updated = state.profile.copyWith(name: name);
    await _updateProfile(updated);
  }

  /// Updates user's avatar path.
  Future<void> updateAvatar(String path) async {
    final updated = state.profile.copyWith(avatarPath: path);
    await _updateProfile(updated);
  }

  /// Updates daily macronutrient targets.
  Future<void> updateMacroTargets(MacroTargets targets) async {
    final updated = state.profile.copyWith(macroTargets: targets);
    await _updateProfile(updated);
  }

  /// Toggles selection of dietary preferences.
  Future<void> toggleDietaryPreference(String preference) async {
    final current = List<String>.from(state.profile.dietaryPreferences);
    if (current.contains(preference)) {
      current.remove(preference);
    } else {
      current.add(preference);
    }
    final updated = state.profile.copyWith(dietaryPreferences: current);
    await _updateProfile(updated);
  }

  /// Adds a food intolerance / allergy.
  Future<void> addAllergy(String allergy) async {
    final current = List<String>.from(state.profile.allergies);
    if (!current.contains(allergy)) {
      current.add(allergy);
      final updated = state.profile.copyWith(allergies: current);
      await _updateProfile(updated);
    }
  }

  /// Removes a food intolerance / allergy.
  Future<void> removeAllergy(String allergy) async {
    final current = List<String>.from(state.profile.allergies);
    if (current.contains(allergy)) {
      current.remove(allergy);
      final updated = state.profile.copyWith(allergies: current);
      await _updateProfile(updated);
    }
  }
}
