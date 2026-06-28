import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/favorites_repository.dart';
import '../../../pantry/data/models/recipe.dart';

/// Concrete implementation of [FavoritesRepository] using [SharedPreferences].
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({required this.prefs});

  final SharedPreferences prefs;
  static const _key = 'favorite_recipes';

  @override
  Future<List<Recipe>> getFavorites() async {
    final raw = prefs.getString(_key);
    if (raw == null) return const [];
    try {
      final list = json.decode(raw) as List;
      return list
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> saveFavorites(List<Recipe> favorites) async {
    final raw = json.encode(favorites.map((r) => r.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
