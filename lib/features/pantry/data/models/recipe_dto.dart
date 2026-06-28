import 'ingredient_dto.dart';
import '../../data/models/recipe.dart';

/// DTO representing a recipe response from the Spoonacular API.
class RecipeDto {
  const RecipeDto({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.missingCount,
    required this.servings,
    required this.costLevel,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeDto.fromJson(Map<String, dynamic> json) {
    // 1. Parse nutrition nutrients
    int calories = 0;
    int protein = 0;
    int carbs = 0;
    int fat = 0;

    final nutrition = json['nutrition'];
    if (nutrition != null && nutrition['nutrients'] != null) {
      final nutrientsList = nutrition['nutrients'] as List;
      for (final n in nutrientsList) {
        final name = n['name'] as String? ?? '';
        final amount = (n['amount'] as num?)?.round() ?? 0;
        if (name == 'Calories') {
          calories = amount;
        } else if (name == 'Protein') {
          protein = amount;
        } else if (name == 'Carbohydrates') {
          carbs = amount;
        } else if (name == 'Fat') {
          fat = amount;
        }
      }
    } else {
      // Sometimes nutrition is flat in search result
      final nutrients = json['nutrients'] as List?;
      if (nutrients != null) {
        for (final n in nutrients) {
          final name = n['name'] as String? ?? '';
          final amount = (n['amount'] as num?)?.round() ?? 0;
          if (name == 'Calories') {
            calories = amount;
          } else if (name == 'Protein') {
            protein = amount;
          } else if (name == 'Carbohydrates') {
            carbs = amount;
          } else if (name == 'Fat') {
            fat = amount;
          }
        }
      }
    }

    // 2. Parse ingredients
    final List<RecipeIngredient> ingredients = [];
    final extendedIngredients = json['extendedIngredients'] as List?;
    if (extendedIngredients != null) {
      for (final item in extendedIngredients) {
        ingredients.add(
          IngredientDto.fromJson(item as Map<String, dynamic>).toDomain(),
        );
      }
    } else {
      // Fallback: missedIngredients + usedIngredients
      final missed = json['missedIngredients'] as List?;
      final used = json['usedIngredients'] as List?;
      if (missed != null) {
        for (final item in missed) {
          ingredients.add(
            IngredientDto.fromJson(item as Map<String, dynamic>).toDomain(),
          );
        }
      }
      if (used != null) {
        for (final item in used) {
          ingredients.add(
            IngredientDto.fromJson(item as Map<String, dynamic>).toDomain(),
          );
        }
      }
    }

    // 3. Parse instruction steps
    final List<CookingStep> instructions = [];
    final analyzedInstructions = json['analyzedInstructions'] as List?;
    if (analyzedInstructions != null && analyzedInstructions.isNotEmpty) {
      final steps = analyzedInstructions[0]['steps'] as List?;
      if (steps != null) {
        for (final step in steps) {
          instructions.add(
            CookingStep(
              stepNumber: step['number'] as int? ?? 1,
              title: 'Step ${step['number']}',
              description: step['step'] as String? ?? '',
            ),
          );
        }
      }
    } else {
      // Flat instructions fallback
      final instructionText = json['instructions'] as String? ?? '';
      if (instructionText.isNotEmpty) {
        instructions.add(
          CookingStep(
            stepNumber: 1,
            title: 'Preparation',
            description: instructionText.replaceAll(RegExp(r'<[^>]*>'), ''),
          ),
        );
      }
    }

    // 4. Cost Level mapping (based on pricePerServing)
    final pricePerServing = (json['pricePerServing'] as num?)?.toDouble() ?? 0.0;
    String costLevel = r'$$';
    if (pricePerServing > 0) {
      if (pricePerServing < 150) {
        costLevel = r'$';
      } else if (pricePerServing > 350) {
        costLevel = r'$$$';
      }
    }

    // 5. Cook Time and Difficulty
    final readyInMinutes = json['readyInMinutes'] as int? ?? 20;
    final difficulty = readyInMinutes < 20
        ? 'Easy'
        : readyInMinutes < 40
            ? 'Medium'
            : 'Hard';

    return RecipeDto(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      cookTimeMinutes: readyInMinutes,
      difficulty: difficulty,
      missingCount: json['missedIngredientCount'] as int? ?? 0,
      servings: json['servings'] as int? ?? 2,
      costLevel: costLevel,
      ingredients: ingredients,
      instructions: instructions,
    );
  }

  final String id;
  final String title;
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

  /// Converts this DTO to the domain [Recipe] entity.
  Recipe toDomain() {
    return Recipe(
      id: id,
      title: title,
      description: 'Enjoy this delicious, fresh meal custom matched to your macros.',
      imageUrl: imageUrl,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      cookTimeMinutes: cookTimeMinutes,
      difficulty: difficulty,
      missingCount: missingCount,
      servings: servings,
      costLevel: costLevel,
      ingredients: ingredients,
      instructions: instructions,
    );
  }
}
