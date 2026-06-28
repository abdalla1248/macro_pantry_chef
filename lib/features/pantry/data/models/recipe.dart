import 'package:equatable/equatable.dart';

/// A single ingredient entry in a recipe.
class RecipeIngredient extends Equatable {
  const RecipeIngredient({
    required this.name,
    required this.amount,
  });

  final String name;
  final String amount;

  @override
  List<Object?> get props => [name, amount];
}

/// A single cooking instruction step.
class CookingStep extends Equatable {
  const CookingStep({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  final int stepNumber;
  final String title;
  final String description;

  @override
  List<Object?> get props => [stepNumber, title, description];
}

/// Represents a full recipe with nutritional info, ingredients, and instructions.
class Recipe extends Equatable {
  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.cookTimeMinutes,
    required this.difficulty,
    this.missingCount = 0,
    this.servings = 2,
    this.costLevel = r'$$',
    this.ingredients = const [],
    this.instructions = const [],
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int cookTimeMinutes;
  final String difficulty;
  final int missingCount;
  final int servings;
  final String costLevel;
  final List<RecipeIngredient> ingredients;
  final List<CookingStep> instructions;
  final bool isFavorite;

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    int? cookTimeMinutes,
    String? difficulty,
    int? missingCount,
    int? servings,
    String? costLevel,
    List<RecipeIngredient>? ingredients,
    List<CookingStep>? instructions,
    bool? isFavorite,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      difficulty: difficulty ?? this.difficulty,
      missingCount: missingCount ?? this.missingCount,
      servings: servings ?? this.servings,
      costLevel: costLevel ?? this.costLevel,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        calories,
        protein,
        carbs,
        fat,
        cookTimeMinutes,
        difficulty,
        missingCount,
        servings,
        costLevel,
        ingredients,
        instructions,
        isFavorite,
      ];
}
