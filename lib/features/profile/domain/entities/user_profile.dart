import 'package:equatable/equatable.dart';

import '../../../pantry/data/models/macro_targets.dart';

/// Entity representing user profile information, dietary settings, and app configurations.
class UserProfile extends Equatable {
  const UserProfile({
    this.name = 'Alex Mercer',
    this.avatarPath,
    this.membershipStatus = 'Premium Member',
    this.macroTargets = const MacroTargets(
      protein: 180,
      carbs: 270,
      fat: 67,
      calories: 2400,
    ),
    this.dietaryPreferences = const [
      'High Protein',
      'Low Sodium',
      'Pescatarian Options'
    ],
    this.allergies = const ['Tree Nuts', 'Shellfish'],
    this.themeMode = 'light',
    this.language = 'en',
  });

  final String name;
  final String? avatarPath;
  final String membershipStatus;
  final MacroTargets macroTargets;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String themeMode;
  final String language;

  UserProfile copyWith({
    String? name,
    String? avatarPath,
    String? membershipStatus,
    MacroTargets? macroTargets,
    List<String>? dietaryPreferences,
    List<String>? allergies,
    String? themeMode,
    String? language,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      macroTargets: macroTargets ?? this.macroTargets,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      allergies: allergies ?? this.allergies,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? 'Alex Mercer',
      avatarPath: json['avatarPath'] as String?,
      membershipStatus: json['membershipStatus'] as String? ?? 'Premium Member',
      macroTargets: json['macroTargets'] != null
          ? MacroTargets(
              protein: json['macroTargets']['protein'] as int? ?? 180,
              carbs: json['macroTargets']['carbs'] as int? ?? 270,
              fat: json['macroTargets']['fat'] as int? ?? 67,
              calories: json['macroTargets']['calories'] as int? ?? 2400,
            )
          : const MacroTargets(
              protein: 180,
              carbs: 270,
              fat: 67,
              calories: 2400,
            ),
      dietaryPreferences: (json['dietaryPreferences'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          const ['High Protein', 'Low Sodium', 'Pescatarian Options'],
      allergies: (json['allergies'] as List?)?.map((e) => e as String).toList() ??
          const ['Tree Nuts', 'Shellfish'],
      themeMode: json['themeMode'] as String? ?? 'light',
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatarPath': avatarPath,
      'membershipStatus': membershipStatus,
      'macroTargets': {
        'protein': macroTargets.protein,
        'carbs': macroTargets.carbs,
        'fat': macroTargets.fat,
        'calories': macroTargets.calories,
      },
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
      'themeMode': themeMode,
      'language': language,
    };
  }

  @override
  List<Object?> get props => [
        name,
        avatarPath,
        membershipStatus,
        macroTargets,
        dietaryPreferences,
        allergies,
        themeMode,
        language,
      ];
}
