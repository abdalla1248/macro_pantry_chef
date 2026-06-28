import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import 'theme_state.dart';

/// Manages light / dark / system theme mode.
///
/// Persists the selected mode to [SharedPreferences] so it survives app restarts.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._prefs) : super(const ThemeState.initial()) {
    _loadSavedTheme();
  }

  final SharedPreferences _prefs;

  /// Restore persisted theme mode.
  void _loadSavedTheme() {
    final saved = _prefs.getString(AppConstants.themeKey);
    if (saved != null) {
      final mode = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
      emit(state.copyWith(themeMode: mode));
    }
  }

  /// Switch to [mode] and persist.
  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _prefs.setString(AppConstants.themeKey, mode.name);
  }

  /// Convenience toggle between light ↔ dark.
  Future<void> toggleTheme() async {
    final next =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }
}
