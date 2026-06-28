import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_pantry_chef/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';
import 'features/pantry/presentation/cubit/pantry_cubit.dart';
import 'features/nutrition/presentation/cubit/macro_target_cubit.dart';
import 'core/localization/language_cubit.dart';
import 'features/profile/data/datasources/profile_local_data_source.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/planner/data/repositories/planner_repository_impl.dart';
import 'features/planner/presentation/cubit/planner_cubit.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/planner/presentation/cubit/shopping_list_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialise Dio with Spoonacular configuration
  DioClient.instance.init(baseUrl: AppConfig.spoonacularBaseUrl);

  runApp(MacroPantryChefApp(prefs: prefs));
}

class MacroPantryChefApp extends StatelessWidget {
  const MacroPantryChefApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final profileRepo = ProfileRepositoryImpl(
      localDataSource: ProfileLocalDataSource(prefs: prefs),
    );
    final plannerRepo = PlannerRepositoryImpl(prefs: prefs);
    final favoritesRepo = FavoritesRepositoryImpl(prefs: prefs);

    return ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit(prefs)),
            BlocProvider<LanguageCubit>(create: (_) => LanguageCubit(prefs)),
            BlocProvider<PantryCubit>(create: (_) => PantryCubit()),
            BlocProvider<ProfileCubit>(
              create: (_) => ProfileCubit(repository: profileRepo),
            ),
            BlocProvider<PlannerCubit>(
              create: (_) => PlannerCubit(repository: plannerRepo),
            ),
            BlocProvider<FavoritesCubit>(
              create: (_) => FavoritesCubit(repository: favoritesRepo),
            ),
            BlocProvider<ShoppingListCubit>(
              create: (_) => ShoppingListCubit(),
            ),
            BlocProvider<MacroTargetCubit>(
              create: (context) => MacroTargetCubit(
                pantryCubit: context.read<PantryCubit>(),
                profileCubit: context.read<ProfileCubit>(),
              )..loadMatchingRecipes(),
            ),
          ],
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  return MaterialApp.router(
                    title: 'Macro Pantry Chef',
                    debugShowCheckedModeBanner: false,

                    // ── Theme ────────────────────────────────────────
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeState.themeMode,

                    // ── Routing ──────────────────────────────────────
                    routerConfig: AppRouter.router,

                    // ── Localisation ─────────────────────────────────
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: locale,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
