import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:macro_pantry_chef/core/theme/app_spacing.dart';
import 'package:macro_pantry_chef/core/extensions/theme_extensions.dart';
import 'package:macro_pantry_chef/core/widgets/recipe_result_card.dart';
import '../cubit/recipe_results_cubit.dart';
import '../cubit/recipe_results_state.dart';

class RecipeResultsScreen extends StatelessWidget {
  const RecipeResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RecipeResultsView();
  }
}

class _RecipeResultsView extends StatelessWidget {
  const _RecipeResultsView();

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
      ),
      body: BlocBuilder<RecipeResultsCubit, RecipeResultsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // Header
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin.w,
                  vertical: AppSpacing.md.h,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.foundOptions(state.recipes.length),
                              style: textTheme.labelMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.xs.h),
                            Text(
                              l10n.matchingRecipes,
                              style: textTheme.displayLarge?.copyWith(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => context.pushNamed('macroFilter'),
                        icon: const Icon(Icons.tune),
                        label: Text(l10n.macroFilter),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.onSurfaceVariant,
                          side: BorderSide(color: scheme.outlineVariant),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm.w,
                            vertical: AppSpacing.xs.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Grid
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin.w,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 400.w,
                    mainAxisSpacing: AppSpacing.md.h,
                    crossAxisSpacing: AppSpacing.md.w,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final recipe = state.recipes[index];
                      return RecipeResultCard(
                        title: recipe.title,
                        imageUrl: recipe.imageUrl,
                        calories: recipe.calories,
                        protein: recipe.protein,
                        carbs: recipe.carbs,
                        fat: recipe.fat,
                        cookTimeMinutes: recipe.cookTimeMinutes,
                        difficulty: recipe.difficulty,
                        missingCount: recipe.missingCount,
                        onTap: () => context.pushNamed(
                          'recipeDetails',
                          pathParameters: {'id': recipe.id},
                        ),
                      );
                    },
                    childCount: state.recipes.length,
                  ),
                ),
              ),
              
              // Bottom padding
              SliverPadding(
                padding: EdgeInsets.only(bottom: AppSpacing.xl.h * 2),
              ),
            ],
          );
        },
      ),
    );
  }
}
