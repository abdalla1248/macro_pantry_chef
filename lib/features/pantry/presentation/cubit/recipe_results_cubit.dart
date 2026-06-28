import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/spoonacular_remote_datasource.dart';
import '../../data/repositories/spoonacular_repository_impl.dart';
import '../../domain/repositories/spoonacular_repository.dart';
import '../../data/models/macro_targets.dart';
import '../../data/models/recipe.dart';
import 'pantry_cubit.dart';
import 'recipe_results_state.dart';

/// Cubit managing recipe discovery, filtering, and macro targeting from Spoonacular API.
class RecipeResultsCubit extends Cubit<RecipeResultsState> {
  RecipeResultsCubit({
    required this.pantryCubit,
    SpoonacularRepository? repository,
  })  : _repository = repository ??
            SpoonacularRepositoryImpl(
              remoteDataSource: SpoonacularRemoteDataSource(),
            ),
        super(const RecipeResultsState());

  final PantryCubit pantryCubit;
  final SpoonacularRepository _repository;
  Timer? _debounceTimer;

  List<String> get _currentIngredients => pantryCubit.state.items
      .where((i) => i.quantity > 0)
      .map((i) => i.name)
      .toList();

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  /// Initial load of recipes matching the user's pantry ingredients.
  Future<void> loadMatchingRecipes() async {
    emit(state.copyWith(isLoading: true));
    try {
      final recipes = await _repository.getMatchingRecipes(
        ingredients: _currentIngredients,
      );
      emit(state.copyWith(recipes: recipes, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Manually triggers macro filter recipe search.
  Future<void> applyMacroFilter(MacroTargets targets) async {
    emit(state.copyWith(isLoading: true));
    try {
      final recipes = await _repository.getRecipesByMacros(
        targets: targets,
        ingredients: _currentIngredients,
      );
      emit(state.copyWith(recipes: recipes, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Updates macro targets locally for instant UI feedback, and triggers a debounced API query.
  void updateMacroTargets(MacroTargets targets) {
    emit(state.copyWith(macroTargets: targets));

    // Debounce the remote query by 600ms to preserve API quota while dragging
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      applyMacroFilter(targets);
    });
  }

  /// Finds a specific recipe by ID.
  Recipe? getRecipeById(String id) {
    try {
      return state.recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
