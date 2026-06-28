import 'package:equatable/equatable.dart';

import '../../domain/entities/meal_plan.dart';

/// State representation for the [PlannerCubit].
class PlannerState extends Equatable {
  const PlannerState({
    required this.selectedDate,
    this.mealPlan = const [],
    this.currentPlan,
    this.isLoading = false,
    this.isWeeklyView = false,
    this.errorMessage,
  });

  final DateTime selectedDate;
  final List<MealPlan> mealPlan;
  final MealPlan? currentPlan;
  final bool isLoading;
  final bool isWeeklyView;
  final String? errorMessage;

  PlannerState copyWith({
    DateTime? selectedDate,
    List<MealPlan>? mealPlan,
    MealPlan? currentPlan,
    bool? isLoading,
    bool? isWeeklyView,
    String? errorMessage,
  }) {
    return PlannerState(
      selectedDate: selectedDate ?? this.selectedDate,
      mealPlan: mealPlan ?? this.mealPlan,
      currentPlan: currentPlan ?? this.currentPlan,
      isLoading: isLoading ?? this.isLoading,
      isWeeklyView: isWeeklyView ?? this.isWeeklyView,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        mealPlan,
        currentPlan,
        isLoading,
        isWeeklyView,
        errorMessage,
      ];
}
