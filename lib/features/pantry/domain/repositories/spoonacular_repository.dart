import '../../data/models/macro_targets.dart';
import '../../data/models/recipe.dart';

/// Repository interface representing the contract for recipe operations.
abstract class SpoonacularRepository {
  /// Resolves matching recipes based on a list of ingredients.
  Future<List<Recipe>> getMatchingRecipes({
    required List<String> ingredients,
  });

  /// Resolves recipes matching a specific daily macronutrient target and ingredients.
  Future<List<Recipe>> getRecipesByMacros({
    required MacroTargets targets,
    List<String>? ingredients,
  });

  /// Resolves full details for a specific recipe.
  Future<Recipe> getRecipeDetail(String id);
}
