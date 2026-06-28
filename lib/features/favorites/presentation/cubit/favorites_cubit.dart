import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../pantry/data/models/recipe.dart';
import '../../domain/repositories/favorites_repository.dart';
import 'favorites_state.dart';

/// Cubit managing loading, toggling, and querying of favorited recipes.
class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required this.repository})
      : super(const FavoritesState()) {
    loadFavorites();
  }

  final FavoritesRepository repository;

  /// Loads all saved favorites from local storage.
  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final list = await repository.getFavorites();
      emit(state.copyWith(favorites: list, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Toggles favorite state of a recipe and saves locally.
  Future<void> toggleFavorite(Recipe recipe) async {
    final current = List<Recipe>.from(state.favorites);
    final index = current.indexWhere((r) => r.id == recipe.id);

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(recipe.copyWith(isFavorite: true));
    }

    emit(state.copyWith(favorites: current));
    await repository.saveFavorites(current);
  }

  /// Query to check if a specific recipe ID is saved as favorite.
  bool isFavorite(String id) {
    return state.favorites.any((r) => r.id == id);
  }
}
