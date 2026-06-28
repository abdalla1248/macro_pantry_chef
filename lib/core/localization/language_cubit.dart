import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application locale, persisting choices to SharedPreferences.
class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(this._prefs) : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  final SharedPreferences _prefs;
  static const _key = 'app_language';

  void _loadSavedLanguage() {
    final code = _prefs.getString(_key) ?? 'en';
    emit(Locale(code));
  }

  /// Change standard locale and persist.
  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_key, languageCode);
    emit(Locale(languageCode));
  }
}
