import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Immutable state for [ThemeCubit].
class ThemeState extends Equatable {
  const ThemeState({required this.themeMode});

  final ThemeMode themeMode;

  /// Default initial state — follows system setting.
  const ThemeState.initial() : themeMode = ThemeMode.system;

  ThemeState copyWith({ThemeMode? themeMode}) =>
      ThemeState(themeMode: themeMode ?? this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
