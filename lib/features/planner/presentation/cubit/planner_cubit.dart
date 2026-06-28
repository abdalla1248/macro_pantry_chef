import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../pantry/data/models/recipe.dart';
import '../../domain/entities/meal_plan.dart';
import '../../domain/repositories/planner_repository.dart';
import 'planner_state.dart';

/// Cubit managing daily and weekly meal scheduler logic and local persistence.
class PlannerCubit extends Cubit<PlannerState> {
  PlannerCubit({required this.repository})
      : super(PlannerState(selectedDate: DateTime.now())) {
    loadMealPlan(state.selectedDate);
  }

  final PlannerRepository repository;

  /// Loads meal plans for the selected date and the surrounding week (for weekly view).
  Future<void> loadMealPlan(DateTime date) async {
    emit(state.copyWith(isLoading: true, selectedDate: date, errorMessage: null));
    try {
      final currentPlan = await repository.getMealPlanForDate(date);

      // Fetch week's plans (7 days starting Monday of that week)
      final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
      final List<MealPlan> weekPlans = [];
      for (int i = 0; i < 7; i++) {
        final day = startOfWeek.add(Duration(days: i));
        weekPlans.add(await repository.getMealPlanForDate(day));
      }

      emit(state.copyWith(
        currentPlan: currentPlan,
        mealPlan: weekPlans,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Toggles between daily and weekly calendar views.
  void toggleView(bool weekly) {
    emit(state.copyWith(isWeeklyView: weekly));
  }

  /// Selects a date and re-loads scheduling info.
  Future<void> selectDate(DateTime date) async {
    await loadMealPlan(date);
  }

  /// Adds a recipe to a specific meal type slot.
  Future<void> addRecipeToPlan(DateTime date, String mealType, Recipe recipe) async {
    if (state.currentPlan == null) return;
    
    // Clear check to make sure we load the targeted date's plan
    final plan = await repository.getMealPlanForDate(date);
    
    final updated = _addRecipeToSlot(plan, mealType, recipe);
    await repository.saveMealPlan(updated);
    await loadMealPlan(state.selectedDate);
  }

  /// Removes a recipe from a specific meal type slot.
  Future<void> removeRecipeFromPlan(DateTime date, String mealType, String recipeId) async {
    final plan = await repository.getMealPlanForDate(date);
    final updated = _removeRecipeFromSlot(plan, mealType, recipeId);
    await repository.saveMealPlan(updated);
    await loadMealPlan(state.selectedDate);
  }

  MealPlan _addRecipeToSlot(MealPlan plan, String mealType, Recipe recipe) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        final list = List<Recipe>.from(plan.breakfast)..add(recipe);
        return plan.copyWith(breakfast: list);
      case 'lunch':
        final list = List<Recipe>.from(plan.lunch)..add(recipe);
        return plan.copyWith(lunch: list);
      case 'dinner':
        final list = List<Recipe>.from(plan.dinner)..add(recipe);
        return plan.copyWith(dinner: list);
      case 'snacks':
      default:
        final list = List<Recipe>.from(plan.snacks)..add(recipe);
        return plan.copyWith(snacks: list);
    }
  }

  MealPlan _removeRecipeFromSlot(MealPlan plan, String mealType, String recipeId) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        final list = List<Recipe>.from(plan.breakfast)
          ..removeWhere((r) => r.id == recipeId);
        return plan.copyWith(breakfast: list);
      case 'lunch':
        final list = List<Recipe>.from(plan.lunch)
          ..removeWhere((r) => r.id == recipeId);
        return plan.copyWith(lunch: list);
      case 'dinner':
        final list = List<Recipe>.from(plan.dinner)
          ..removeWhere((r) => r.id == recipeId);
        return plan.copyWith(dinner: list);
      case 'snacks':
      default:
        final list = List<Recipe>.from(plan.snacks)
          ..removeWhere((r) => r.id == recipeId);
        return plan.copyWith(snacks: list);
    }
  }
}
