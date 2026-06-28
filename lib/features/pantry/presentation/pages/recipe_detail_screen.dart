import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:share_plus/share_plus.dart';

import 'package:macro_pantry_chef/core/theme/app_radius.dart';
import 'package:macro_pantry_chef/core/theme/app_spacing.dart';
import 'package:macro_pantry_chef/core/extensions/theme_extensions.dart';
import 'package:macro_pantry_chef/core/widgets/glass_card.dart';
import 'package:macro_pantry_chef/core/widgets/translated_text.dart';
import '../../../nutrition/presentation/cubit/macro_target_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../planner/presentation/cubit/planner_cubit.dart';
import '../../../pantry/data/models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    return _RecipeDetailView(recipeId: recipeId);
  }
}

class _RecipeDetailView extends StatelessWidget {
  const _RecipeDetailView({required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    
    // Find recipe (in a real app this might be an async load)
    final recipe = context.read<MacroTargetCubit>().getRecipeById(recipeId);
    
    if (recipe == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.recipeNotFound)),
      );
    }

    final isFavorite = context.watch<FavoritesCubit>().isFavorite(recipe.id);
    
    final routerState = GoRouterState.of(context);
    final planDateStr = routerState.uri.queryParameters['planDate'];
    final mealType = routerState.uri.queryParameters['mealType'];

    return Scaffold(
      backgroundColor: scheme.surface,
      body: CustomScrollView(
        slivers: [
          // Hero Image AppBar
          SliverAppBar(
            expandedHeight: 442.h,
            pinned: true,
            backgroundColor: scheme.surface,
            leading: Padding(
              padding: EdgeInsets.all(8.r),
              child: _GlassIconButton(
                icon: Icons.arrow_back,
                onPressed: () => context.pop(),
                color: scheme.primary,
              ),
            ),
            actions: [
              _GlassIconButton(
                icon: Icons.share,
                onPressed: () {
                  final text = '${recipe.title}\n\n'
                      'Calories: ${recipe.calories.round()} kcal\n'
                      'Protein: ${recipe.protein.round()}g | Carbs: ${recipe.carbs.round()}g | Fat: ${recipe.fat.round()}g\n\n'
                      'Shared from Macro Pantry Chef';
                  Share.share(text);
                },
                color: scheme.onSurfaceVariant,
              ),
              SizedBox(width: 8.w),
              _GlassIconButton(
                icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                onPressed: () => context.read<FavoritesCubit>().toggleFavorite(recipe),
                color: isFavorite ? Colors.red : scheme.onSurfaceVariant,
              ),
              SizedBox(width: 16.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -32.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Info Card
                    GlassCard(
                      borderRadius: AppRadius.xl,
                      padding: EdgeInsets.all(AppSpacing.md.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TranslatedText(
                                  recipe.title,
                                  style: textTheme.displayMedium?.copyWith(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: scheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(999.r),
                                ),
                                child: Text(
                                  recipe.costLevel,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: scheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.sm.h),
                          TranslatedText(
                            recipe.description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          
                          // Macros Grid
                          Row(
                            children: [
                              Expanded(
                                child: _MacroStat(
                                  label: l10n.caloriesLabel,
                                  value: '${recipe.calories}',
                                  color: scheme.onSurfaceVariant,
                                  bgColor: scheme.surface.withValues(alpha: 0.5),
                                  borderColor: scheme.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _MacroStat(
                                  label: l10n.proteinLabel,
                                  value: '${recipe.protein}g',
                                  color: scheme.primary,
                                  bgColor: scheme.primaryContainer.withValues(alpha: 0.2),
                                  borderColor: scheme.primary.withValues(alpha: 0.1),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _MacroStat(
                                  label: l10n.carbsLabel,
                                  value: '${recipe.carbs}g',
                                  color: scheme.primary,
                                  bgColor: scheme.surface.withValues(alpha: 0.5),
                                  borderColor: scheme.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _MacroStat(
                                  label: l10n.fatLabel,
                                  value: '${recipe.fat}g',
                                  color: scheme.primary,
                                  bgColor: scheme.surface.withValues(alpha: 0.5),
                                  borderColor: scheme.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md.h),
                          
                          // Meta row
                          Row(
                            children: [
                              Icon(Icons.timer, size: 18.sp, color: scheme.onSurfaceVariant),
                              SizedBox(width: 4.w),
                              Text(
                                '${recipe.cookTimeMinutes} ${l10n.mins}',
                                style: textTheme.labelMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Icon(Icons.restaurant, size: 18.sp, color: scheme.onSurfaceVariant),
                              SizedBox(width: 4.w),
                              Text(
                                '${recipe.servings} ${l10n.servings}',
                                style: textTheme.labelMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xl.h),
                    
                    // Ingredients
                    Text(
                      l10n.ingredients,
                      style: textTheme.headlineMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    ...recipe.ingredients.map((ing) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 8.h),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: scheme.outlineVariant.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TranslatedText(
                                  ing.name,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurface,
                                  ),
                                ),
                                TranslatedText(
                                  ing.amount,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                        
                    SizedBox(height: AppSpacing.xl.h),
                    
                    // Instructions
                    Text(
                      l10n.cookingInstructions,
                      style: textTheme.headlineMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    ...recipe.instructions.map((step) => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: scheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${step.stepNumber}',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: scheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TranslatedText(
                                      step.title,
                                      style: textTheme.headlineSmall?.copyWith(
                                        color: scheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    TranslatedText(
                                      step.description,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                        
                    SizedBox(height: AppSpacing.xl.h),
                    
                    // Buttons
                    FilledButton.icon(
                      onPressed: () {
                        context.pushNamed('cookingMode', pathParameters: {'id': recipe.id});
                      },
                      icon: const Icon(Icons.local_dining),
                      label: Text(l10n.cookNow),
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    OutlinedButton.icon(
                      onPressed: () => _showMealSlotSelector(context, recipe),
                      icon: const Icon(Icons.bookmark_add),
                      label: Text(l10n.saveToPlanner),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.primary,
                        side: BorderSide(color: scheme.outline),
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        backgroundColor: scheme.surface,
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xl.h * 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: (planDateStr != null && mealType != null)
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin.w,
                  vertical: AppSpacing.sm.h,
                ),
                child: FilledButton(
                  onPressed: () {
                    final date = DateTime.parse(planDateStr);
                    context.read<PlannerCubit>().addRecipeToPlan(date, mealType, recipe);
                    context.goNamed('planner');
                  },
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text('Add to Meal Plan (${mealType.toUpperCase()})'),
                ),
              ),
            )
          : null,
    );
  }

  void _showMealSlotSelector(BuildContext context, Recipe recipe) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (bottomSheetContext) {
        final scheme = bottomSheetContext.color;
        final textTheme = bottomSheetContext.textTheme;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add to Planner',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm.h),
                for (final slot in ['Breakfast', 'Lunch', 'Dinner', 'Snack'])
                  ListTile(
                    leading: Icon(Icons.restaurant, color: scheme.primary),
                    title: Text(slot),
                    onTap: () {
                      final now = DateTime.now();
                      context
                          .read<PlannerCubit>()
                          .addRecipeToPlan(now, slot.toLowerCase(), recipe);
                      Navigator.pop(bottomSheetContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${recipe.title} added to Today\'s $slot!',
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MacroStat extends StatelessWidget {
  const _MacroStat({
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  final String label;
  final String value;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
