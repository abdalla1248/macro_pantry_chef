import '../../../../core/network/dio_client.dart';
import '../models/recipe_dto.dart';

/// Data source interface for fetching recipe and nutrition data from the Spoonacular API.
class SpoonacularRemoteDataSource {
  final DioClient _dioClient = DioClient.instance;

  /// Fetches recipes from Spoonacular based on a list of ingredients.
  ///
  /// Leverages Spoonacular's `recipes/complexSearch` with `includeIngredients`
  /// to fetch nutrition and ready time data in a single request.
  Future<List<RecipeDto>> searchRecipesByIngredients({
    required List<String> ingredients,
    int number = 10,
  }) async {
    final response = await _dioClient.get(
      'recipes/complexSearch',
      queryParameters: {
        'includeIngredients': ingredients.join(','),
        'fillIngredients': true,
        'addRecipeInformation': true,
        'addRecipeNutrition': true,
        'number': number,
      },
    );
    final data = response.data as Map<String, dynamic>?;
    final results = data?['results'] as List?;
    if (results == null) return [];
    return results
        .map((item) => RecipeDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches recipes filtered by macronutrient ranges.
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
    int number = 10,
  }) async {
    final queryParameters = {
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

    final response = await _dioClient.get(
      'recipes/complexSearch',
      queryParameters: queryParameters,
    );
    final data = response.data as Map<String, dynamic>?;
    final results = data?['results'] as List?;
    if (results == null) return [];
    return results
        .map((item) => RecipeDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches complete recipe details (including ingredients, macros, and steps) by id.
  Future<RecipeDto> getRecipeInformation(String id) async {
    final response = await _dioClient.get(
      'recipes/$id/information',
      queryParameters: {
        'includeNutrition': true,
      },
    );
    return RecipeDto.fromJson(response.data as Map<String, dynamic>);
  }
}
