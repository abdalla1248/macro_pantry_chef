import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macro_pantry_chef/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/cubit/theme_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialise Dio (base URL will be set in Phase 3)
  DioClient.instance.init();

  runApp(MacroPantryChefApp(prefs: prefs));
}

class MacroPantryChefApp extends StatelessWidget {
  const MacroPantryChefApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        AppConstants.designWidth,
        AppConstants.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (_) => ThemeCubit(prefs),
          child: BlocBuilder<ThemeCubit, ThemeState>(
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
                locale: const Locale('en'),
              );
            },
          ),
        );
      },
    );
  }
}
