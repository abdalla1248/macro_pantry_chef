import '../../../pantry/data/models/recipe.dart';

/// Repository interface contract for retrieving and saving the user's favorite recipes.
abstract class FavoritesRepository {
  /// Loads all saved favorite recipes.
  Future<List<Recipe>> getFavorites();

  /// Persists the list of favorites.
  Future<void> saveFavorites(List<Recipe> favorites);
}
