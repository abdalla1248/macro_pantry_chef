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

    if (diets != null && diets.isNotEmpty) {
      queryParameters['diet'] = diets.join(',');
    }

    if (intolerances != null && intolerances.isNotEmpty) {
      queryParameters['intolerances'] = intolerances.join(',');
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

  /// Fetches complete recipe details.
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
