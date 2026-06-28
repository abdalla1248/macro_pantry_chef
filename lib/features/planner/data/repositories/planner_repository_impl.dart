import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/meal_plan.dart';
import '../../domain/repositories/planner_repository.dart';

/// Concrete implementation of [PlannerRepository] using date-indexed keys in [SharedPreferences].
class PlannerRepositoryImpl implements PlannerRepository {
  PlannerRepositoryImpl({required this.prefs});

  final SharedPreferences prefs;
  static const _prefix = 'meal_plan_';

  @override
  Future<MealPlan> getMealPlanForDate(DateTime date) async {
    final key = '$_prefix${_dateKey(date)}';
    final raw = prefs.getString(key);
    if (raw == null) {
      return MealPlan(date: date);
    }
    try {
      return MealPlan.fromJson(
        json.decode(raw) as Map<String, dynamic>,
        date,
      );
    } catch (_) {
      return MealPlan(date: date);
    }
  }

  @override
  Future<void> saveMealPlan(MealPlan plan) async {
    final key = '$_prefix${_dateKey(plan.date)}';
    await prefs.setString(key, json.encode(plan.toJson()));
  }

  String _dateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
