import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/home/presentation/pages/main_shell.dart';
import '../../features/pantry/presentation/pages/macro_filter_screen.dart';
import '../../features/pantry/presentation/pages/pantry_screen.dart';
import '../../features/pantry/presentation/pages/recipe_detail_screen.dart';
import '../../features/pantry/presentation/pages/recipe_results_screen.dart';
import '../../features/pantry/presentation/pages/cooking_mode_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/planner/presentation/pages/planner_screen.dart';
import '../../features/favorites/presentation/pages/favorites_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';

/// Centralised application routing using GoRouter.
///
/// Uses [StatefulShellRoute.indexedStack] for bottom-navigation tabs
/// so that each branch preserves its own navigation state.
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // ── Splash ──────────────────────────────────────────────────────
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // ── Main Shell (Bottom Navigation) ──────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          // Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Pantry
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pantry',
                name: 'pantry',
                builder: (context, state) => const PantryScreen(),
                routes: [
                  GoRoute(
                    path: 'results',
                    name: 'recipeResults',
                    builder: (context, state) => const RecipeResultsScreen(),
                  ),
                  GoRoute(
                    path: 'filter',
                    name: 'macroFilter',
                    builder: (context, state) => const MacroFilterScreen(),
                  ),
                  GoRoute(
                    path: 'recipe/:id',
                    name: 'recipeDetails',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return RecipeDetailScreen(recipeId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'cook',
                        name: 'cookingMode',
                        builder: (context, state) {
                          final id = state.pathParameters['id'] ?? '';
                          return CookingModeScreen(recipeId: id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Planner
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/planner',
                name: 'planner',
                builder: (context, state) => const PlannerScreen(),
              ),
            ],
          ),

          // Favorites
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),

          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
