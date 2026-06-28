import '../../domain/entities/meal_plan.dart';

/// Repository interface contract for scheduling and loading daily meal plans.
abstract class PlannerRepository {
  /// Loads the scheduled meal plan for a specific date.
  Future<MealPlan> getMealPlanForDate(DateTime date);

  /// Persists a modified meal plan locally.
  Future<void> saveMealPlan(MealPlan plan);
}
