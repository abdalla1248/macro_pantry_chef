import 'package:equatable/equatable.dart';

import '../../data/models/macro_targets.dart';
import '../../data/models/recipe.dart';

/// State for the Recipe Results and Macro Filter screens.
class RecipeResultsState extends Equatable {
  const RecipeResultsState({
    this.recipes = const [],
    this.macroTargets = const MacroTargets(),
    this.isLoading = false,
  });

  final List<Recipe> recipes;
  final MacroTargets macroTargets;
  final bool isLoading;

  int get matchCount => recipes.length;

  RecipeResultsState copyWith({
    List<Recipe>? recipes,
    MacroTargets? macroTargets,
    bool? isLoading,
  }) {
    return RecipeResultsState(
      recipes: recipes ?? this.recipes,
      macroTargets: macroTargets ?? this.macroTargets,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [recipes, macroTargets, isLoading];
}
