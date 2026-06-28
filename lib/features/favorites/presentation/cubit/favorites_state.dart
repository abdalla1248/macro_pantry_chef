import 'package:equatable/equatable.dart';

import '../../../pantry/data/models/recipe.dart';

/// State representation for the [FavoritesCubit].
class FavoritesState extends Equatable {
  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Recipe> favorites;
  final bool isLoading;
  final String? errorMessage;

  FavoritesState copyWith({
    List<Recipe>? favorites,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [favorites, isLoading, errorMessage];
}
