import '../../../pantry/data/models/macro_targets.dart';
import '../../../pantry/data/models/recipe.dart';

/// Repository interface representing the contract for nutrition and recipe discovery.
abstract class NutritionRepository {
  /// Searches recipes based on available ingredients.
  Future<List<Recipe>> getMatchingRecipes({
    required List<String> ingredients,
  });

  /// Searches recipes filtered by macronutrient goals and preferences.
  Future<List<Recipe>> getRecipesByMacros({
    required MacroTargets targets,
    List<String>? ingredients,
    List<String>? diets,
    List<String>? intolerances,
  });

  /// Resolves full details for a specific recipe.
  Future<Recipe> getRecipeDetail(String id);
}
