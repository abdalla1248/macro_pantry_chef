import 'package:equatable/equatable.dart';

import '../../../pantry/data/models/recipe.dart';

/// Entity representing the scheduled meals for a specific calendar date.
class MealPlan extends Equatable {
  const MealPlan({
    required this.date,
    this.breakfast = const [],
    this.lunch = const [],
    this.dinner = const [],
    this.snacks = const [],
  });

  final DateTime date;
  final List<Recipe> breakfast;
  final List<Recipe> lunch;
  final List<Recipe> dinner;
  final List<Recipe> snacks;

  /// Returns the formatted key 'yyyy-MM-dd' for local storage indexing.
  String get dateKey =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  MealPlan copyWith({
    DateTime? date,
    List<Recipe>? breakfast,
    List<Recipe>? lunch,
    List<Recipe>? dinner,
    List<Recipe>? snacks,
  }) {
    return MealPlan(
      date: date ?? this.date,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snacks: snacks ?? this.snacks,
    );
  }

  factory MealPlan.fromJson(Map<String, dynamic> json, DateTime date) {
    List<Recipe> parseRecipes(String key) {
      final list = json[key] as List?;
      if (list == null) return const [];
      // We store recipes as JSON, map back
      return list
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return MealPlan(
      date: date,
      breakfast: parseRecipes('breakfast'),
      lunch: parseRecipes('lunch'),
      dinner: parseRecipes('dinner'),
      snacks: parseRecipes('snacks'),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> serializeRecipes(List<Recipe> list) {
      return list.map((r) => r.toJson()).toList();
    }

    return {
      'breakfast': serializeRecipes(breakfast),
      'lunch': serializeRecipes(lunch),
      'dinner': serializeRecipes(dinner),
      'snacks': serializeRecipes(snacks),
    };
  }

  @override
  List<Object?> get props => [date, breakfast, lunch, dinner, snacks];
}
