import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/nutrition_remote_data_source.dart';
import '../../data/repositories/nutrition_repository_impl.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../../../pantry/presentation/cubit/pantry_cubit.dart';
import '../../../pantry/data/models/macro_targets.dart';
import '../../../pantry/data/models/recipe.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import 'macro_target_state.dart';

/// Cubit managing macro targets, real-time recipe discovery, and Spoonacular queries.
class MacroTargetCubit extends Cubit<MacroTargetState> {
  MacroTargetCubit({
    required this.pantryCubit,
    required this.profileCubit,
    NutritionRepository? repository,
  })  : _repository = repository ??
            NutritionRepositoryImpl(
              remoteDataSource: NutritionRemoteDataSource(),
            ),
        super(const MacroTargetState());

  final PantryCubit pantryCubit;
  final ProfileCubit profileCubit;
  final NutritionRepository _repository;
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

  /// Initial load of recipes matching the user's pantry ingredients and profile preferences.
  Future<void> loadMatchingRecipes() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profile = profileCubit.state.profile;
      final ingredients = _currentIngredients;

      if (kDebugMode) {
        log(
          '🚀 loadMatchingRecipes\n'
          '   Ingredients (${ingredients.length}): $ingredients\n'
          '   Diets: ${profile.dietaryPreferences}\n'
          '   Allergies: ${profile.allergies}\n'
          '   Macro targets: P=${profile.macroTargets.protein} '
          'C=${profile.macroTargets.carbs} '
          'F=${profile.macroTargets.fat} '
          'Cal=${profile.macroTargets.calories}',
          name: 'MacroTargetCubit',
        );
      }

      final recipes = await _repository.getRecipesByMacros(
        targets: profile.macroTargets,
        ingredients: ingredients,
        diets: profile.dietaryPreferences,
        intolerances: profile.allergies,
      );

      if (kDebugMode) {
        log(
          '✅ loadMatchingRecipes completed\n'
          '   Recipes returned: ${recipes.length}\n'
          '   Titles: ${recipes.map((r) => r.title).toList()}',
          name: 'MacroTargetCubit',
        );
      }

      emit(state.copyWith(
        recipes: recipes,
        macroTargets: profile.macroTargets,
        isLoading: false,
      ));
    } catch (e) {
      if (kDebugMode) {
        log(
          '❌ loadMatchingRecipes ERROR: $e',
          name: 'MacroTargetCubit',
        );
      }
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Manually triggers macro filter recipe search.
  Future<void> applyMacroFilter(MacroTargets targets) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final profile = profileCubit.state.profile;
      final recipes = await _repository.getRecipesByMacros(
        targets: targets,
        ingredients: _currentIngredients,
        diets: profile.dietaryPreferences,
        intolerances: profile.allergies,
      );

      if (kDebugMode) {
        log(
          '✅ applyMacroFilter completed — ${recipes.length} recipes',
          name: 'MacroTargetCubit',
        );
      }

      emit(state.copyWith(recipes: recipes, isLoading: false));
    } catch (e) {
      if (kDebugMode) {
        log(
          '❌ applyMacroFilter ERROR: $e',
          name: 'MacroTargetCubit',
        );
      }
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
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
