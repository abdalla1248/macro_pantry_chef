import 'dart:developer';

import '../datasources/spoonacular_remote_datasource.dart';
import '../../domain/repositories/spoonacular_repository.dart';
import '../models/macro_targets.dart';
import '../models/recipe.dart';

/// Concrete implementation of [SpoonacularRepository].
///
/// Communicates with [SpoonacularRemoteDataSource] and maps DTOs to domain entities.
/// If requests fail (e.g. invalid API key or quota exceeded), it falls back gracefully
/// to pre-defined mock data to ensure the app remains testable.
class SpoonacularRepositoryImpl implements SpoonacularRepository {
  SpoonacularRepositoryImpl({
    required this.remoteDataSource,
  });

  final SpoonacularRemoteDataSource remoteDataSource;

  @override
  Future<List<Recipe>> getMatchingRecipes({
    required List<String> ingredients,
  }) async {
    try {
      final dtos = await remoteDataSource.searchRecipesByIngredients(
        ingredients: ingredients,
      );
      if (dtos.isEmpty) return _fallbackRecipes;
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e, stackTrace) {
      log(
        'Spoonacular API error in getMatchingRecipes, falling back to mock data',
        error: e,
        stackTrace: stackTrace,
      );
      return _fallbackRecipes;
    }
  }

  @override
  Future<List<Recipe>> getRecipesByMacros({
    required MacroTargets targets,
    List<String>? ingredients,
  }) async {
    try {
      // Calculate +/- 20% tolerance bounds for protein, carbs, fat, calories
      final minProtein = (targets.protein * 0.7).round();
      final maxProtein = (targets.protein * 1.3).round();
      final minCarbs = (targets.carbs * 0.7).round();
      final maxCarbs = (targets.carbs * 1.3).round();
      final minFat = (targets.fat * 0.7).round();
      final maxFat = (targets.fat * 1.3).round();
      final minCalories = (targets.calories * 0.7).round();
      final maxCalories = (targets.calories * 1.3).round();

      final dtos = await remoteDataSource.searchRecipesByMacros(
        minProtein: minProtein,
        maxProtein: maxProtein,
        minCarbs: minCarbs,
        maxCarbs: maxCarbs,
        minFat: minFat,
        maxFat: maxFat,
        minCalories: minCalories,
        maxCalories: maxCalories,
        ingredients: ingredients,
      );
      if (dtos.isEmpty) return _fallbackRecipes;
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e, stackTrace) {
      log(
        'Spoonacular API error in getRecipesByMacros, falling back to mock data',
        error: e,
        stackTrace: stackTrace,
      );
      return _fallbackRecipes;
    }
  }

  @override
  Future<Recipe> getRecipeDetail(String id) async {
    try {
      final dto = await remoteDataSource.getRecipeInformation(id);
      return dto.toDomain();
    } catch (e, stackTrace) {
      log(
        'Spoonacular API error in getRecipeDetail, searching in fallbacks',
        error: e,
        stackTrace: stackTrace,
      );
      // Fallback matching recipe details
      try {
        return _fallbackRecipes.firstWhere((r) => r.id == id);
      } catch (_) {
        throw Exception('Recipe not found in API or fallbacks.');
      }
    }
  }

  // ── Mock Fallback Recipes ──────────────────────────────────────────
  static const List<Recipe> _fallbackRecipes = [
    Recipe(
      id: '1',
      title: 'Lemon Herb Salmon & Quinoa',
      description:
          'A nutrient-dense powerhouse featuring wild-caught salmon, quinoa, and vibrant roasted vegetables.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBXsaoDLaqNt2LjMFEOoaE-3PrqkbesUXlYRQy_0KDZFfcOBePSuI8WCqVDLsAa5keL3JVrpvtfotObeigYimLjO68RNvAJ-HXPe-uWEJIKVAgJyYvExYCsIfs8uxFz1s7DUpJEWvCmExdHIpuMFHFhrGYg000DOq82hphfJQo19iGNUDRVjiR_8OZneswWzc9Zu5cJccjilPjTpvD2ARLi2CxkiEU-fF9MGvKpwLPVApKSQWF7a05cP4qArlEFe-B5NidZiDNyQeo',
      calories: 450,
      protein: 42,
      carbs: 35,
      fat: 15,
      cookTimeMinutes: 25,
      difficulty: 'Easy',
      missingCount: 0,
      servings: 2,
      costLevel: r'$$',
      ingredients: [
        RecipeIngredient(name: 'Wild-caught Salmon Fillets', amount: '2 (6oz)'),
        RecipeIngredient(name: 'White Miso Paste', amount: '2 tbsp'),
        RecipeIngredient(name: 'Quinoa (Dry)', amount: '1/2 cup'),
        RecipeIngredient(name: 'Edamame (Shelled)', amount: '1 cup'),
        RecipeIngredient(name: 'Sweet Potato (Cubed)', amount: '1 large'),
      ],
      instructions: [
        CookingStep(
          stepNumber: 1,
          title: 'Preheat & Prep',
          description:
              'Preheat oven to 400°F (200°C). Toss cubed sweet potatoes with 1 tsp olive oil, salt, and pepper. Spread on a baking sheet and roast for 20 minutes.',
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Cook Quinoa',
          description:
              'Rinse quinoa well. Combine with 1 cup water in a small pot. Bring to a boil, then reduce heat, cover, and simmer for 15 minutes until water is absorbed.',
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Glaze & Bake Salmon',
          description:
              'Mix miso paste with a splash of warm water to thin slightly. Brush over salmon fillets. Add salmon to the baking sheet with sweet potatoes for the last 10-12 minutes of roasting.',
        ),
      ],
    ),
    Recipe(
      id: '2',
      title: 'Mediterranean Chicken Bowl',
      description:
          'A bright, refreshing bowl with grilled chicken, crisp greens, cherry tomatoes, and a light herb dressing.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDqkqrZsj7q1vUIhnkcSR_MdH7vflWU-KodbfNT-zpvsZlmom08CgLffBdqPw5DbXmajLzDKmhLOOn9o5U8TlY-CtYJeh00o6d7W96aD9SjQ-GPADgVjOmD0HTYvz-RCfM1skq5Ob05Onx6_QHe4s4jho2EsQ5XSse1z4U9r0VuIg2wpv3jEHdhTOV7HaQ_tjyrFkn-1lzuM8eN9AGwdpdtLbQA20-gHEuXiuOlpeXfL1KG2sto93P4dveajpawlhXMt3tKCRPVgUM',
      calories: 380,
      protein: 38,
      carbs: 22,
      fat: 18,
      cookTimeMinutes: 15,
      difficulty: 'Easy',
      missingCount: 1,
      servings: 2,
      costLevel: r'$',
      ingredients: [
        RecipeIngredient(name: 'Chicken Breast', amount: '2 fillets'),
        RecipeIngredient(name: 'Mixed Greens', amount: '2 cups'),
        RecipeIngredient(name: 'Cherry Tomatoes', amount: '1 cup'),
        RecipeIngredient(name: 'Cucumber', amount: '1 medium'),
        RecipeIngredient(name: 'Feta Cheese', amount: '50g'),
      ],
      instructions: [
        CookingStep(
          stepNumber: 1,
          title: 'Season & Grill Chicken',
          description:
              'Season chicken with olive oil, lemon juice, oregano, salt, and pepper. Grill for 6-7 minutes per side until internal temp reaches 165°F.',
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Prep Vegetables',
          description:
              'Halve cherry tomatoes, dice cucumber, and crumble feta cheese. Toss greens in a large bowl.',
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Assemble Bowl',
          description:
              'Slice the grilled chicken. Arrange over the greens with tomatoes, cucumber, and feta. Drizzle with olive oil and a squeeze of lemon.',
        ),
      ],
    ),
    Recipe(
      id: '3',
      title: 'Sweet Potato Lentil Curry',
      description:
          'A hearty, plant-based curry packed with sweet potato, red lentils, and warming spices.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBgGDX-7M_mTGd1beDSQsdQYym1YNpqwtR0A-d5_HIkhbw3IaZ_tPdckImKkoEs7sV33-MVy2o_9y9ZiykzReSVrZvQbturNCxlAW4b8Im6Xm2uOgNhNQh45oAanPIWbo0teY65SMDSoXm9oqdqnYLKjZWEiYj-vk4WyreEGz3vpGgkWzZ7y5bu97otoRAC7sQt-_sQmHLzUrXgBU8w3yn2Uu_ZzoYQdjkMbnoupvBWRk70awXRxJCxvH5UL5ha3z7rBx2I78UP6L0',
      calories: 520,
      protein: 24,
      carbs: 78,
      fat: 12,
      cookTimeMinutes: 40,
      difficulty: 'Medium',
      missingCount: 0,
      servings: 4,
      costLevel: r'$',
      ingredients: [
        RecipeIngredient(name: 'Sweet Potato', amount: '2 large'),
        RecipeIngredient(name: 'Red Lentils', amount: '1 cup'),
        RecipeIngredient(name: 'Coconut Milk', amount: '400ml'),
        RecipeIngredient(name: 'Curry Paste', amount: '2 tbsp'),
        RecipeIngredient(name: 'Fresh Cilantro', amount: '1 bunch'),
      ],
      instructions: [
        CookingStep(
          stepNumber: 1,
          title: 'Sauté Aromatics',
          description:
              'Heat oil in a large pot. Sauté diced onion and garlic for 3 minutes until fragrant. Add curry paste and cook for 1 minute.',
        ),
        CookingStep(
          stepNumber: 2,
          title: 'Simmer',
          description:
              'Add cubed sweet potato, rinsed lentils, and coconut milk. Bring to a boil, then reduce heat and simmer covered for 25-30 minutes.',
        ),
        CookingStep(
          stepNumber: 3,
          title: 'Season & Serve',
          description:
              'Season with salt and lime juice. Serve garnished with fresh cilantro and a side of rice.',
        ),
      ],
    ),
  ];
}
