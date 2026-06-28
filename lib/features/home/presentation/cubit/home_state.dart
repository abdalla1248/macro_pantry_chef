import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ── Placeholder Data Models (Phase 1 only) ────────────────────────────────




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
    required this.filters,
  });

  final HomeStatus status;
  final List<FilterCategory> filters;

  /// Phase 1 initial state with hardcoded placeholder data.
  factory HomeState.initial() => const HomeState(
        status: HomeStatus.loaded,
        filters: _placeholderFilters,
      );

  HomeState copyWith({
    HomeStatus? status,
    List<FilterCategory>? filters,
  }) =>
      HomeState(
        status: status ?? this.status,
        filters: filters ?? this.filters,
      );

  @override
  List<Object?> get props => [
        status,
        filters,
      ];
}

// ── Static Placeholder Data ──────────────────────────────────────────────




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
