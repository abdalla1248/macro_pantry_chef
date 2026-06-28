import 'dart:developer';

import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/nutrition_remote_data_source.dart';
import '../../../pantry/data/models/macro_targets.dart';
import '../../../pantry/data/models/recipe.dart';

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
      final dtos = await remoteDataSource.searchRecipesByIngredients(
        ingredients: ingredients,
      );
      if (dtos.isEmpty) return [];
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e, stackTrace) {
      log(
        'Nutrition API error in getMatchingRecipes',
        error: e,
        stackTrace: stackTrace,
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
      // Divide daily targets by expected meals per day (e.g., 3) to get per-serving thresholds
      const mealsPerDay = 3;
      final perMealProtein = targets.protein / mealsPerDay;
      final perMealCarbs = targets.carbs / mealsPerDay;
      final perMealFat = targets.fat / mealsPerDay;
      final perMealCalories = targets.calories / mealsPerDay;

      // Calculate +/- 30% tolerance bounds per meal
      final minProtein = (perMealProtein * 0.7).round();
      final maxProtein = (perMealProtein * 1.3).round();
      final minCarbs = (perMealCarbs * 0.7).round();
      final maxCarbs = (perMealCarbs * 1.3).round();
      final minFat = (perMealFat * 0.7).round();
      final maxFat = (perMealFat * 1.3).round();
      final minCalories = (perMealCalories * 0.7).round();
      final maxCalories = (perMealCalories * 1.3).round();

      // Map diets to standard Spoonacular parameters if needed
      final standardDiets = diets?.map((d) {
        final lower = d.toLowerCase();
        if (lower.contains('pescatarian')) return 'pescetarian';
        if (lower.contains('keto')) return 'ketogenic';
        if (lower.contains('gluten')) return 'gluten free';
        return lower;
      }).toList();

      final standardIntolerances = intolerances?.map((i) {
        final lower = i.toLowerCase();
        if (lower.contains('tree')) return 'tree nut';
        if (lower.contains('peanut')) return 'peanut';
        if (lower.contains('shellfish')) return 'shellfish';
        if (lower.contains('seafood')) return 'seafood';
        if (lower.contains('dairy')) return 'dairy';
        if (lower.contains('soy')) return 'soy';
        if (lower.contains('wheat')) return 'wheat';
        return lower;
      }).toList();

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
        diets: standardDiets,
        intolerances: standardIntolerances,
      );
      if (dtos.isEmpty) return [];
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e, stackTrace) {
      log(
        'Nutrition API error in getRecipesByMacros',
        error: e,
        stackTrace: stackTrace,
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
      );
      rethrow;
    }
  }
}
