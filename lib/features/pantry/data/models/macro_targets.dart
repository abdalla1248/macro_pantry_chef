import 'package:equatable/equatable.dart';

/// Holds the user's daily macro nutritional targets.
class MacroTargets extends Equatable {
  const MacroTargets({
    this.protein = 120,
    this.carbs = 250,
    this.fat = 65,
    this.calories = 2100,
  });

  final int protein;
  final int carbs;
  final int fat;
  final int calories;

  MacroTargets copyWith({
    int? protein,
    int? carbs,
    int? fat,
    int? calories,
  }) {
    return MacroTargets(
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      calories: calories ?? this.calories,
    );
  }

  /// Total grams (protein + carbs + fat) — used for chart proportions.
  int get totalGrams => protein + carbs + fat;

  double get proteinRatio => totalGrams > 0 ? protein / totalGrams : 0;
  double get carbsRatio => totalGrams > 0 ? carbs / totalGrams : 0;
  double get fatRatio => totalGrams > 0 ? fat / totalGrams : 0;

  @override
  List<Object?> get props => [protein, carbs, fat, calories];
}
