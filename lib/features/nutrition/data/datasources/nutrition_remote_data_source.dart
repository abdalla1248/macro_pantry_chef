import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../../../core/network/dio_client.dart';
import '../../../pantry/data/models/recipe_dto.dart';

/// Remote data source for fetching nutrition and recipe data from Spoonacular.
class NutritionRemoteDataSource {
  final DioClient _dioClient = DioClient.instance;

  /// Searches recipes matching a list of ingredients with complete nutrition details.
  Future<List<RecipeDto>> searchRecipesByIngredients({
    required List<String> ingredients,
    int number = 10,
  }) async {
    final queryParameters = {
      'includeIngredients': ingredients.join(','),
      'fillIngredients': true,
      'addRecipeInformation': true,
      'addRecipeNutrition': true,
      'number': number,
    };

    if (kDebugMode) {
      log(
        '🌐 searchRecipesByIngredients\n'
        '   Endpoint: recipes/complexSearch\n'
        '   Query: $queryParameters',
        name: 'NutritionDataSource',
      );
    }

    final response = await _dioClient.get(
      'recipes/complexSearch',
      queryParameters: queryParameters,
    );

    final data = response.data as Map<String, dynamic>?;
    final results = data?['results'] as List?;

    if (kDebugMode) {
      log(
        '🌐 searchRecipesByIngredients response\n'
        '   Status: ${response.statusCode}\n'
        '   Total results: ${data?['totalResults']}\n'
        '   Results in page: ${results?.length ?? 0}',
        name: 'NutritionDataSource',
      );
    }

    if (results == null || results.isEmpty) return [];
    return results
        .map((item) => RecipeDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Searches recipes matching macro ranges, ingredients, diets, and intolerances.
  Future<List<RecipeDto>> searchRecipesByMacros({
    required int minProtein,
    required int maxProtein,
    required int minCarbs,
    required int maxCarbs,
    required int minFat,
    required int maxFat,
    required int minCalories,
    required int maxCalories,
    List<String>? ingredients,
    List<String>? diets,
    List<String>? intolerances,
    int number = 10,
  }) async {
    final queryParameters = <String, dynamic>{
      'minProtein': minProtein,
      'maxProtein': maxProtein,
      'minCarbs': minCarbs,
      'maxCarbs': maxCarbs,
      'minFat': minFat,
      'maxFat': maxFat,
      'minCalories': minCalories,
      'maxCalories': maxCalories,
      'fillIngredients': true,
      'addRecipeInformation': true,
      'addRecipeNutrition': true,
      'number': number,
    };

    if (ingredients != null && ingredients.isNotEmpty) {
      queryParameters['includeIngredients'] = ingredients.join(',');
    }

    if (diets != null && diets.isNotEmpty) {
      queryParameters['diet'] = diets.join(',');
    }

    if (intolerances != null && intolerances.isNotEmpty) {
      queryParameters['intolerances'] = intolerances.join(',');
    }

    if (kDebugMode) {
      log(
        '🌐 searchRecipesByMacros\n'
        '   Endpoint: recipes/complexSearch\n'
        '   Query: $queryParameters',
        name: 'NutritionDataSource',
      );
    }

    final response = await _dioClient.get(
      'recipes/complexSearch',
      queryParameters: queryParameters,
    );

    final data = response.data as Map<String, dynamic>?;
    final results = data?['results'] as List?;

    if (kDebugMode) {
      log(
        '🌐 searchRecipesByMacros response\n'
        '   Status: ${response.statusCode}\n'
        '   Total results: ${data?['totalResults']}\n'
        '   Results in page: ${results?.length ?? 0}',
        name: 'NutritionDataSource',
      );
    }

    if (results == null || results.isEmpty) return [];
    return results
        .map((item) => RecipeDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches complete recipe details.
  Future<RecipeDto> getRecipeInformation(String id) async {
    if (kDebugMode) {
      log(
        '🌐 getRecipeInformation for id=$id',
        name: 'NutritionDataSource',
      );
    }

    final response = await _dioClient.get(
      'recipes/$id/information',
      queryParameters: {
        'includeNutrition': true,
      },
    );
    return RecipeDto.fromJson(response.data as Map<String, dynamic>);
  }
}
