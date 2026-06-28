import 'package:flutter/material.dart';
import 'package:macro_pantry_chef/l10n/app_localizations.dart';

/// Convenience extensions on [BuildContext] for theming and localization.
extension ThemeExtensions on BuildContext {
  /// Shortcut for `Theme.of(this).colorScheme`.
  ColorScheme get color => Theme.of(this).colorScheme;

  /// Shortcut for `Theme.of(this).textTheme`.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Current [Brightness] (light or dark).
  Brightness get brightness => Theme.of(this).brightness;

  /// Whether the current theme is dark mode.
  bool get isDark => brightness == Brightness.dark;

  /// Shortcut for `AppLocalizations.of(this)!`.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;
}
