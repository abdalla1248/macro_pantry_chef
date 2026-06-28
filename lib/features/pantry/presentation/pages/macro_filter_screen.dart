import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:macro_pantry_chef/core/theme/app_spacing.dart';
import 'package:macro_pantry_chef/core/extensions/theme_extensions.dart';
import 'package:macro_pantry_chef/core/widgets/donut_chart.dart';
import 'package:macro_pantry_chef/core/widgets/glass_card.dart';
import 'package:macro_pantry_chef/core/widgets/macro_slider_card.dart';
import '../cubit/recipe_results_cubit.dart';
import '../cubit/recipe_results_state.dart';

class MacroFilterScreen extends StatelessWidget {
  const MacroFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MacroFilterView();
  }
}

class _MacroFilterView extends StatelessWidget {
  const _MacroFilterView();

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.macroTargets,
          style: textTheme.titleLarge?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<RecipeResultsCubit, RecipeResultsState>(
        builder: (context, state) {
          final targets = state.macroTargets;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              final visualColumn = Column(
                children: [
                  DonutChart(
                    proteinRatio: targets.proteinRatio,
                    carbsRatio: targets.carbsRatio,
                    fatRatio: targets.fatRatio,
                    centerText: targets.calories.toString(),
                    centerLabel: l10n.calories.toUpperCase(),
                    size: 240,
                  ),
                  SizedBox(height: AppSpacing.xl.h),
                  _MatchPreviewCard(matchCount: state.matchCount),
                ],
              );

              final controlsColumn = Column(
                children: [
                  MacroSliderCard(
                    icon: Icons.fitness_center,
                    iconColor: scheme.secondaryContainer,
                    iconBackgroundColor:
                        scheme.secondaryContainer.withValues(alpha: 0.2),
                    title: l10n.protein,
                    subtitle: 'Muscle repair & growth',
                    value: targets.protein.toDouble(),
                    valueColor: scheme.secondaryContainer,
                    unit: 'g',
                    min: 0,
                    max: 250,
                    onChanged: (val) => context
                        .read<RecipeResultsCubit>()
                        .updateMacroTargets(
                            targets.copyWith(protein: val.toInt())),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  MacroSliderCard(
                    icon: Icons.agriculture,
                    iconColor: scheme.primaryContainer,
                    iconBackgroundColor:
                        scheme.primaryContainer.withValues(alpha: 0.2),
                    title: l10n.carbohydrates,
                    subtitle: 'Primary energy source',
                    value: targets.carbs.toDouble(),
                    valueColor: scheme.primaryContainer,
                    unit: 'g',
                    min: 0,
                    max: 400,
                    onChanged: (val) => context
                        .read<RecipeResultsCubit>()
                        .updateMacroTargets(
                            targets.copyWith(carbs: val.toInt())),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  MacroSliderCard(
                    icon: Icons.water_drop,
                    iconColor: scheme.tertiary,
                    iconBackgroundColor:
                        scheme.tertiary.withValues(alpha: 0.4),
                    title: l10n.fats,
                    subtitle: 'Hormone & brain health',
                    value: targets.fat.toDouble(),
                    valueColor: scheme.tertiary,
                    unit: 'g',
                    min: 0,
                    max: 150,
                    onChanged: (val) => context
                        .read<RecipeResultsCubit>()
                        .updateMacroTargets(
                            targets.copyWith(fat: val.toInt())),
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  MacroSliderCard(
                    icon: Icons.local_fire_department,
                    iconColor: scheme.onSurfaceVariant,
                    iconBackgroundColor: scheme.surfaceContainerHighest,
                    title: l10n.calories,
                    subtitle: 'Daily limit cap',
                    value: targets.calories.toDouble(),
                    valueColor: scheme.primary,
                    unit: 'kcal',
                    min: 1200,
                    max: 4000,
                    step: 50,
                    onChanged: (val) => context
                        .read<RecipeResultsCubit>()
                        .updateMacroTargets(
                            targets.copyWith(calories: val.toInt())),
                  ),
                ],
              );

              if (isWide) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg.w,
                    vertical: AppSpacing.md.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: visualColumn),
                      SizedBox(width: AppSpacing.xl.w),
                      Expanded(flex: 7, child: controlsColumn),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin.w,
                  vertical: AppSpacing.md.h,
                ),
                child: Column(
                  children: [
                    visualColumn,
                    SizedBox(height: AppSpacing.xl.h),
                    controlsColumn,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MatchPreviewCard extends StatelessWidget {
  const _MatchPreviewCard({required this.matchCount});

  final int matchCount;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.r),
      borderRadius: BorderRadius.circular(16.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AVAILABLE RECIPES',
                style: textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    matchCount.toString(),
                    style: textTheme.headlineMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'matches',
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          FilledButton.icon(
            onPressed: () => context.pushNamed('recipeResults'),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.viewMenu),
          ),
        ],
      ),
    );
  }
}
