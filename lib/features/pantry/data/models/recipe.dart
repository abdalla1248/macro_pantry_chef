import 'package:equatable/equatable.dart';

/// A single ingredient entry in a recipe.
class RecipeIngredient extends Equatable {
  const RecipeIngredient({
    required this.name,
    required this.amount,
  });

  final String name;
  final String amount;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
    };
  }

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'stepNumber': stepNumber,
      'title': title,
      'description': description,
    };
  }

  factory CookingStep.fromJson(Map<String, dynamic> json) {
    return CookingStep(
      stepNumber: json['stepNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'cookTimeMinutes': cookTimeMinutes,
      'difficulty': difficulty,
      'missingCount': missingCount,
      'servings': servings,
      'costLevel': costLevel,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions.map((i) => i.toJson()).toList(),
      'isFavorite': isFavorite,
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      protein: json['protein'] as int? ?? 0,
      carbs: json['carbs'] as int? ?? 0,
      fat: json['fat'] as int? ?? 0,
      cookTimeMinutes: json['cookTimeMinutes'] as int? ?? 20,
      difficulty: json['difficulty'] as String? ?? 'Easy',
      missingCount: json['missingCount'] as int? ?? 0,
      servings: json['servings'] as int? ?? 2,
      costLevel: json['costLevel'] as String? ?? r'$$',
      ingredients: (json['ingredients'] as List?)
              ?.map((item) => RecipeIngredient.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      instructions: (json['instructions'] as List?)
              ?.map((item) => CookingStep.fromJson(item as Map<String, dynamic>))
              .toList() ??
          const [],
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

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
