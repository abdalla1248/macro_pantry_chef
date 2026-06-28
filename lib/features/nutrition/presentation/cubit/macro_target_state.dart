import 'package:equatable/equatable.dart';

import '../../../pantry/data/models/macro_targets.dart';
import '../../../pantry/data/models/recipe.dart';

/// State representation for the [MacroTargetCubit].
class MacroTargetState extends Equatable {
  const MacroTargetState({
    this.recipes = const [],
    this.macroTargets = const MacroTargets(),
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Recipe> recipes;
  final MacroTargets macroTargets;
  final bool isLoading;
  final String? errorMessage;

  MacroTargetState copyWith({
    List<Recipe>? recipes,
    MacroTargets? macroTargets,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MacroTargetState(
      recipes: recipes ?? this.recipes,
      macroTargets: macroTargets ?? this.macroTargets,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [recipes, macroTargets, isLoading, errorMessage];
}
