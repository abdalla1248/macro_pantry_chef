import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ── Placeholder Data Models (Phase 1 only) ────────────────────────────────

/// Lightweight recipe data for placeholder cards.
class RecipePlaceholder extends Equatable {
  const RecipePlaceholder({
    required this.titleKey,
    required this.descriptionKey,
    required this.imageUrl,
    required this.rating,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.cookTimeMinutes,
  });

  /// Localisation key for the title (resolved via l10n at the widget level).
  final String titleKey;
  final String descriptionKey;
  final String imageUrl;
  final double rating;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final int cookTimeMinutes;

  @override
  List<Object?> get props => [
        titleKey,
        descriptionKey,
        imageUrl,
        rating,
        proteinGrams,
        carbsGrams,
        fatGrams,
        cookTimeMinutes,
      ];
}

/// Lightweight ingredient data.
class IngredientPlaceholder extends Equatable {
  const IngredientPlaceholder({
    required this.nameKey,
    required this.dotColorIndex,
  });

  final String nameKey;

  /// 0 = primary, 1 = secondaryContainer, 2 = tertiary, 3 = outline
  final int dotColorIndex;

  @override
  List<Object?> get props => [nameKey, dotColorIndex];
}

/// Quick filter category.
class FilterCategory extends Equatable {
  const FilterCategory({
    required this.labelKey,
    required this.icon,
    required this.colorIndex,
  });

  final String labelKey;
  final IconData icon;

  /// 0 = primary, 1 = tertiary, 2 = primaryContainer, 3 = surfaceTint,
  /// 4 = secondary, 5 = outline
  final int colorIndex;

  @override
  List<Object?> get props => [labelKey, icon, colorIndex];
}

// ── Home State ────────────────────────────────────────────────────────────

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.recommendations,
    required this.pantryItems,
    required this.pantryItemCount,
    required this.filters,
  });

  final HomeStatus status;
  final List<RecipePlaceholder> recommendations;
  final List<IngredientPlaceholder> pantryItems;
  final int pantryItemCount;
  final List<FilterCategory> filters;

  /// Phase 1 initial state with hardcoded placeholder data.
  factory HomeState.initial() => const HomeState(
        status: HomeStatus.loaded,
        pantryItemCount: 42,
        recommendations: _placeholderRecipes,
        pantryItems: _placeholderIngredients,
        filters: _placeholderFilters,
      );

  HomeState copyWith({
    HomeStatus? status,
    List<RecipePlaceholder>? recommendations,
    List<IngredientPlaceholder>? pantryItems,
    int? pantryItemCount,
    List<FilterCategory>? filters,
  }) =>
      HomeState(
        status: status ?? this.status,
        recommendations: recommendations ?? this.recommendations,
        pantryItems: pantryItems ?? this.pantryItems,
        pantryItemCount: pantryItemCount ?? this.pantryItemCount,
        filters: filters ?? this.filters,
      );

  @override
  List<Object?> get props => [
        status,
        recommendations,
        pantryItems,
        pantryItemCount,
        filters,
      ];
}

// ── Static Placeholder Data ──────────────────────────────────────────────

const _placeholderRecipes = [
  RecipePlaceholder(
    titleKey: 'grilledSalmonBowl',
    descriptionKey: 'grilledSalmonDesc',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBGOIDkqAV3nZoOmZ9adecyBPHX4dY3I8qHVcq5WRy-pqOtveA-rKbTCU_WWQF7MN-ZG-iRw3ra9lRroJ8H5gkz0EDH5uVyXbBxvDv413dpG5skkiVsomck7COKcsNNwzX-AOdl8kYnPE_ivnTeSiCQnVmK3l_PeReP2SZTlw3ePPo2jHG8xTZ86KKbjevbIMFlwl3lzYekh-75rmsWX0xfEyc4D92Vx4dONvYUvul5auPTgMC9_a4YYHBVWV06yNlFwd6RZjmjm7k',
    rating: 4.9,
    proteinGrams: 45,
    carbsGrams: 12,
    fatGrams: 22,
    cookTimeMinutes: 25,
  ),
  RecipePlaceholder(
    titleKey: 'chickpeaSalad',
    descriptionKey: 'chickpeaSaladDesc',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAAOuSby65RFvp74FMV0Hl8NTvtF_xzbMbeWbg5FKxnMKTD96L3xC6ug0Me_jUbZyVqZ_WmCFFs8cVTVz80WNsJ_tN40-AqFxRx1O5srguKpCz1J5-XP9BdtPrzk_veqpQISz4opUSW4GqBrUipjgI5yfykEC3gOECi0lSVhwjtIW3pbbsGCQtEELsEAmI-bmx0QFzwWZX0yGLO_OdnjK6c3Bioy-Ebuy9moGGv2k05y9r8XWEPVJxRSCNKII_c9mr6tbhLFP2YiVo',
    rating: 4.7,
    proteinGrams: 18,
    carbsGrams: 42,
    fatGrams: 15,
    cookTimeMinutes: 10,
  ),
];

const _placeholderIngredients = [
  IngredientPlaceholder(nameKey: 'chickenBreast', dotColorIndex: 0),
  IngredientPlaceholder(nameKey: 'sweetPotato', dotColorIndex: 1),
  IngredientPlaceholder(nameKey: 'broccoli', dotColorIndex: 2),
  IngredientPlaceholder(nameKey: 'quinoa', dotColorIndex: 3),
];

const _placeholderFilters = [
  FilterCategory(
    labelKey: 'highProtein',
    icon: Icons.fitness_center,
    colorIndex: 0,
  ),
  FilterCategory(
    labelKey: 'lowCarb',
    icon: Icons.grain,
    colorIndex: 1,
  ),
  FilterCategory(
    labelKey: 'vegetarian',
    icon: Icons.eco,
    colorIndex: 2,
  ),
  FilterCategory(
    labelKey: 'vegan',
    icon: Icons.spa,
    colorIndex: 3,
  ),
  FilterCategory(
    labelKey: 'keto',
    icon: Icons.set_meal,
    colorIndex: 4,
  ),
  FilterCategory(
    labelKey: 'glutenFree',
    icon: Icons.block,
    colorIndex: 5,
  ),
];
