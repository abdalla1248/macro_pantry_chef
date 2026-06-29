import 'dart:developer';

import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/nutrition_remote_data_source.dart';
import '../../../pantry/data/models/macro_targets.dart';
import '../../../pantry/data/models/recipe.dart';

/// Valid Spoonacular diet values.
///
/// Any dietary preference from the user profile that does NOT map to one of
/// these is a nutritional goal (e.g. "High Protein", "Low Sodium") and must
/// be handled via macro filters, NOT the `diet` query parameter.
const _validSpoonacularDiets = <String>{
  'gluten free',
  'ketogenic',
  'vegetarian',
  'lacto-vegetarian',
  'ovo-vegetarian',
  'vegan',
  'pescetarian',
  'paleo',
  'primal',
  'whole30',
};

/// Concrete implementation of [NutritionRepository] for the nutrition feature.
class NutritionRepositoryImpl implements NutritionRepository {
  NutritionRepositoryImpl({
    required this.remoteDataSource,
  });

  final NutritionRemoteDataSource remoteDataSource;

  @override
  Future<List<Recipe>> getMatchingRecipes({
    required List<String> ingredients,
  }) async {
    try {
      log(
        '📦 getMatchingRecipes called with ${ingredients.length} ingredients: $ingredients',
        name: 'NutritionRepository',
      );
      final dtos = await remoteDataSource.searchRecipesByIngredients(
        ingredients: ingredients,
      );
      log(
        '📦 getMatchingRecipes returned ${dtos.length} DTOs',
        name: 'NutritionRepository',
      );
      if (dtos.isEmpty) return [];
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e, stackTrace) {
      log(
        '📦 getMatchingRecipes ERROR',
        error: e,
        stackTrace: stackTrace,
        name: 'NutritionRepository',
      );
      rethrow;
    }
  }

  @override
  Future<List<Recipe>> getRecipesByMacros({
    required MacroTargets targets,
    List<String>? ingredients,
    List<String>? diets,
    List<String>? intolerances,
  }) async {
    try {
      // ── 1. Divide daily targets by meals-per-day for per-serving bounds ──
      const mealsPerDay = 3;
      final perMealProtein = targets.protein / mealsPerDay;
      final perMealCarbs = targets.carbs / mealsPerDay;
      final perMealFat = targets.fat / mealsPerDay;
      final perMealCalories = targets.calories / mealsPerDay;

      final minProtein = (perMealProtein * 0.5).round();
      final maxProtein = (perMealProtein * 1.5).round();
      final minCarbs = (perMealCarbs * 0.5).round();
      final maxCarbs = (perMealCarbs * 1.5).round();
      final minFat = (perMealFat * 0.5).round();
      final maxFat = (perMealFat * 1.5).round();
      final minCalories = (perMealCalories * 0.5).round();
      final maxCalories = (perMealCalories * 1.5).round();

      // ── 2. Map user dietary preferences to valid Spoonacular diet values ──
      //
      // "High Protein", "Low Sodium", "Low Carb" are nutritional goals, NOT
      // Spoonacular diets.  Sending them causes the API to return 0 results.
      final standardDiets = <String>[];
      if (diets != null) {
        for (final d in diets) {
          final mapped = _mapDiet(d);
          if (mapped != null && _validSpoonacularDiets.contains(mapped)) {
            standardDiets.add(mapped);
          } else {
            log(
              '⚠️ Skipping non-diet preference "$d" (mapped: "$mapped") — '
              'not a valid Spoonacular diet parameter',
              name: 'NutritionRepository',
            );
          }
        }
      }

      // ── 3. Map intolerances ──
      final standardIntolerances = intolerances?.map((i) {
        final lower = i.toLowerCase();
        if (lower.contains('tree')) return 'tree nut';
        return lower;
      }).toList();

      log(
        '🔍 getRecipesByMacros query:\n'
        '   Daily targets: P=${targets.protein}g C=${targets.carbs}g F=${targets.fat}g Cal=${targets.calories}\n'
        '   Per-meal bounds: P=$minProtein-$maxProtein C=$minCarbs-$maxCarbs F=$minFat-$maxFat Cal=$minCalories-$maxCalories\n'
        '   Ingredients: $ingredients\n'
        '   Diets (filtered): $standardDiets\n'
        '   Intolerances: $standardIntolerances',
        name: 'NutritionRepository',
      );

      final dtos = await remoteDataSource.searchRecipesByMacros(
        minProtein: minProtein,
        maxProtein: maxProtein,
        minCarbs: minCarbs,
        maxCarbs: maxCarbs,
        minFat: minFat,
        maxFat: maxFat,
        minCalories: minCalories,
        maxCalories: maxCalories,
        ingredients: ingredients,
        diets: standardDiets.isEmpty ? null : standardDiets,
        intolerances: standardIntolerances,
      );

      log(
        '🔍 getRecipesByMacros returned ${dtos.length} DTOs',
        name: 'NutritionRepository',
      );
      if (dtos.isEmpty) return [];
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e, stackTrace) {
      log(
        '🔍 getRecipesByMacros ERROR',
        error: e,
        stackTrace: stackTrace,
        name: 'NutritionRepository',
      );
      rethrow;
    }
  }

  @override
  Future<Recipe> getRecipeDetail(String id) async {
    try {
      final dto = await remoteDataSource.getRecipeInformation(id);
      return dto.toDomain();
    } catch (e, stackTrace) {
      log(
        'Nutrition API error in getRecipeDetail',
        error: e,
        stackTrace: stackTrace,
        name: 'NutritionRepository',
      );
      rethrow;
    }
  }

  /// Maps user-facing dietary preferences to Spoonacular-compatible diet strings.
  /// Returns `null` for preferences that are nutritional goals, not diets.
  String? _mapDiet(String userPreference) {
    final lower = userPreference.toLowerCase().trim();
    // Nutritional goals — NOT diets. Return null so they are filtered out.
    if (lower.contains('high protein')) return null;
    if (lower.contains('low sodium')) return null;
    if (lower.contains('low carb')) return null;
    if (lower.contains('low fat')) return null;

    // Actual diets
    if (lower.contains('pescatarian')) return 'pescetarian';
    if (lower.contains('keto')) return 'ketogenic';
    if (lower.contains('gluten')) return 'gluten free';
    if (lower.contains('vegetarian')) return 'vegetarian';
    if (lower.contains('vegan')) return 'vegan';
    if (lower.contains('paleo')) return 'paleo';
    if (lower.contains('whole30')) return 'whole30';

    // Unknown — return as-is, will be filtered by _validSpoonacularDiets check
    return lower;
  }
}
