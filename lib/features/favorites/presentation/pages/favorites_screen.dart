import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/recipe_result_card.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

/// Screen listing the user's favorited recipes.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        toolbarHeight: 64.h,
        backgroundColor: scheme.surface.withO(0.8),
        title: Row(
          children: [
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
                  errorBuilder: (_, __, ___) => Icon(Icons.person, color: scheme.outline),
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
            icon: Icon(Icons.notifications_outlined, color: scheme.onSurface, size: 24.sp),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = state.favorites;

          return CustomScrollView(
            slivers: [
              // Title Header
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin.w,
                  vertical: AppSpacing.md.h,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.favorites,
                        style: textTheme.displayMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.favoritesSubtitle,
                        style: AppTextStyles.bodyMd(context).copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (list.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64.sp, color: scheme.outlineVariant),
                        SizedBox(height: 16.h),
                        Text(
                          l10n.noSavedRecipes,
                          style: AppTextStyles.headlineSm(context).copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          l10n.saveRecipeInstructions,
                          style: AppTextStyles.labelSm(context).copyWith(color: scheme.outline),
                        ),
                      ],
                    ),
                  ),
                )
              else
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
                        final recipe = list[index];
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
                      childCount: list.length,
                    ),
                  ),
                ),

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
