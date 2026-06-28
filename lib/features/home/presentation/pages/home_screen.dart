import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/recipe_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Home Dashboard — pixel-perfect to Stitch "Home Dashboard" screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  // Helper to resolve l10n keys to localised strings.
  String _resolveKey(BuildContext context, String key) {
    final l10n = context.l10n;
    return switch (key) {
      'grilledSalmonBowl' => l10n.grilledSalmonBowl,
      'grilledSalmonDesc' => l10n.grilledSalmonDesc,
      'chickpeaSalad' => l10n.chickpeaSalad,
      'chickpeaSaladDesc' => l10n.chickpeaSaladDesc,
      'chickenBreast' => l10n.chickenBreast,
      'sweetPotato' => l10n.sweetPotato,
      'broccoli' => l10n.broccoli,
      'quinoa' => l10n.quinoa,
      'highProtein' => l10n.highProtein,
      'lowCarb' => l10n.lowCarb,
      'vegetarian' => l10n.vegetarian,
      'vegan' => l10n.vegan,
      'keto' => l10n.keto,
      'glutenFree' => l10n.glutenFree,
      _ => key,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Top App Bar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            floating: false,
            toolbarHeight: 64.h,
            backgroundColor: scheme.surface.withO(0.8),
            flexibleSpace: ClipRect(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withO(0.05),
                      blurRadius: 8.r,
                    ),
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                // User Avatar
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      AppConstants.userAvatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        Icons.person,
                        color: scheme.outline,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm.w),
                Text(
                  l10n.appName,
                  style: AppTextStyles.headlineMd(context).copyWith(
                    color: scheme.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: scheme.onSurface,
                  size: 24.sp,
                ),
                tooltip: l10n.notifications,
              ),
              SizedBox(width: 8.w),
            ],
          ),

          // ── Content ─────────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin.w,
            ),
            sliver: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return SliverList.list(
                  children: [
                    SizedBox(height: AppSpacing.md.h),

                    // ── Search Bar ───────────────────────────────
                    AppSearchBar(hint: l10n.searchHint),

                    SizedBox(height: AppSpacing.lg.h),

                    // ── Ingredients I Have Card ──────────────────
                    _IngredientsCard(
                      ingredients: state.pantryItems,
                      itemCount: state.pantryItemCount,
                      resolveKey: (key) => _resolveKey(context, key),
                    ),

                    SizedBox(height: AppSpacing.lg.h),

                    // ── Today's Recommendations ─────────────────
                    SectionHeader(title: l10n.todaysRecommendations),
                    SizedBox(height: AppSpacing.sm.h),
                  ],
                );
              },
            ),
          ),

          // ── Recommendations Carousel (needs full-bleed) ────────
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 280.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.containerMargin.w,
                    ),
                    itemCount: state.recommendations.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(width: AppSpacing.gutter.w),
                    itemBuilder: (context, index) {
                      final recipe = state.recommendations[index];
                      return RecipeCard(
                        title: _resolveKey(context, recipe.titleKey),
                        description:
                            _resolveKey(context, recipe.descriptionKey),
                        imageUrl: recipe.imageUrl,
                        rating: recipe.rating,
                        proteinGrams: recipe.proteinGrams,
                        carbsGrams: recipe.carbsGrams,
                        fatGrams: recipe.fatGrams,
                        cookTime:
                            '${recipe.cookTimeMinutes}${context.l10n.minutes}',
                        proteinLabel: context.l10n.protein,
                        carbsLabel: context.l10n.carbs,
                        fatLabel: context.l10n.fat,
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // ── Quick Filters ─────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.containerMargin.w,
            ),
            sliver: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return SliverList.list(
                  children: [
                    SizedBox(height: AppSpacing.lg.h),
                    SectionHeader(title: l10n.quickFilters),
                    SizedBox(height: AppSpacing.md.h),
                    _FiltersGrid(
                      filters: state.filters,
                      resolveKey: (key) => _resolveKey(context, key),
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ingredients I Have Card ──────────────────────────────────────────────
class _IngredientsCard extends StatelessWidget {
  const _IngredientsCard({
    required this.ingredients,
    required this.itemCount,
    required this.resolveKey,
  });

  final List<IngredientPlaceholder> ingredients;
  final int itemCount;
  final String Function(String key) resolveKey;

  Color _dotColor(BuildContext context, int index) {
    final scheme = context.color;
    return switch (index) {
      0 => scheme.primary,
      1 => scheme.secondaryContainer,
      2 => scheme.tertiary,
      _ => scheme.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final l10n = context.l10n;

    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Stack(
        children: [
          // Gradient blob
          Positioned(
            right: -40.w,
            top: -40.h,
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.tertiaryFixed.withO(0.5),
              ),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.ingredientsIHave,
                    style: AppTextStyles.headlineSm(context),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      l10n.managePantry,
                      style: AppTextStyles.labelMd(context).copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs.h),
              Text(
                l10n.ingredientCount(itemCount),
                style: AppTextStyles.bodyMd(context).copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.sm.h),

              // Ingredient chips
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  ...ingredients.map((ing) => _IngredientChip(
                        label: resolveKey(ing.nameKey),
                        dotColor: _dotColor(context, ing.dotColorIndex),
                      )),
                  // Add Item button
                  _AddItemChip(
                    label: l10n.addItem,
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Generate Meal Ideas Button
              SizedBox(
                width: double.infinity,
                child: Material(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(16.r),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: scheme.onPrimary,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.generateMealIdeas,
                            style: AppTextStyles.labelMd(context).copyWith(
                              color: scheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Ingredient Chip ──────────────────────────────────────────────────────
class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.label, required this.dotColor});

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTextStyles.labelSm(context),
          ),
        ],
      ),
    );
  }
}

// ── Add Item Chip ────────────────────────────────────────────────────────
class _AddItemChip extends StatelessWidget {
  const _AddItemChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: scheme.onPrimary, size: 16.sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTextStyles.labelSm(context).copyWith(
                color: scheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filters Grid ─────────────────────────────────────────────────────────
class _FiltersGrid extends StatelessWidget {
  const _FiltersGrid({
    required this.filters,
    required this.resolveKey,
  });

  final List<FilterCategory> filters;
  final String Function(String key) resolveKey;

  // Map colorIndex to (icon bg, icon fg, hover bg, hover fg) pairs
  (Color, Color) _colors(BuildContext context, int index) {
    final scheme = context.color;
    return switch (index) {
      0 => (scheme.primary.withO(0.1), scheme.primary),
      1 => (scheme.tertiary.withO(0.1), scheme.tertiary),
      2 => (scheme.primaryContainer.withO(0.2), scheme.primaryContainer),
      3 => (scheme.surfaceTint.withO(0.1), scheme.surfaceTint),
      4 => (scheme.secondaryContainer.withO(0.2), scheme.secondary),
      _ => (scheme.outlineVariant.withO(0.3), scheme.outline),
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.sm.w,
      mainAxisSpacing: AppSpacing.sm.h,
      childAspectRatio: 1.0,
      children: filters.map((filter) {
        final (bg, fg) = _colors(context, filter.colorIndex);
        return GlassCard(
          borderRadius: BorderRadius.circular(16.r),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: bg,
                    ),
                    child: Icon(filter.icon, color: fg, size: 24.sp),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    resolveKey(filter.labelKey),
                    style: AppTextStyles.labelSm(context).copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
