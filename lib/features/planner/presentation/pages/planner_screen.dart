import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/theme_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/donut_chart.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../pantry/data/models/recipe.dart';
import '../../../pantry/data/models/macro_targets.dart';
import '../../../pantry/presentation/cubit/pantry_cubit.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import 'shopping_list_modal.dart';
import '../../domain/entities/meal_plan.dart';
import '../cubit/planner_cubit.dart';
import '../cubit/planner_state.dart';

/// Meal Planner Screen showing calendar date scroller, macro progress indicators, and meal slots.
class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PlannerView();
  }
}

class _PlannerView extends StatelessWidget {
  const _PlannerView();

  List<DateTime> _getWeekDays(DateTime selectedDate) {
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  void _openShoppingList(BuildContext context, List<Recipe> plannedRecipes) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PantryCubit>(),
          child: ShoppingListModal(plannedRecipes: plannedRecipes),
        );
      },
    );
  }

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
              final plan = context.read<PlannerCubit>().state.currentPlan ?? MealPlan(date: DateTime.now());
              final allRecipes = [
                ...plan.breakfast,
                ...plan.lunch,
                ...plan.dinner,
                ...plan.snacks,
              ];
                  
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => ShoppingListModal(plannedRecipes: allRecipes),
              );
            },
            icon: Icon(Icons.shopping_cart_outlined, color: scheme.primary, size: 24.sp),
            tooltip: l10n.shoppingList,
          ),
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
      body: BlocBuilder<PlannerCubit, PlannerState>(
        builder: (context, state) {
          final selectedDate = state.selectedDate;
          final plan = state.currentPlan ?? MealPlan(date: selectedDate);
          final profile = context.watch<ProfileCubit>().state.profile;
          final targets = profile.macroTargets;

          // Combine all scheduled recipes for the day
          final List<Recipe> allDayRecipes = [
            ...plan.breakfast,
            ...plan.lunch,
            ...plan.dinner,
            ...plan.snacks,
          ];

          // Compute totals
          final totalCalories = allDayRecipes.fold<int>(0, (sum, r) => sum + r.calories);
          final totalProtein = allDayRecipes.fold<int>(0, (sum, r) => sum + r.protein);
          final totalCarbs = allDayRecipes.fold<int>(0, (sum, r) => sum + r.carbs);
          final totalFat = allDayRecipes.fold<int>(0, (sum, r) => sum + r.fat);

          final remainingCalories = targets.calories - totalCalories;

          return Column(
            children: [
              // ── Header & View Toggle ──────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin.w,
                  vertical: AppSpacing.sm.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Planner',
                          style: textTheme.displayMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Design your fuel for the day.',
                          style: AppTextStyles.bodyMd(context).copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    // Daily/Weekly toggle
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.read<PlannerCubit>().toggleView(false),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: !state.isWeeklyView ? scheme.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Daily',
                                style: AppTextStyles.labelSm(context).copyWith(
                                  color: !state.isWeeklyView ? scheme.onPrimary : scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<PlannerCubit>().toggleView(true),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: state.isWeeklyView ? scheme.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Weekly',
                                style: AppTextStyles.labelSm(context).copyWith(
                                  color: state.isWeeklyView ? scheme.onPrimary : scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (state.isWeeklyView)
                Expanded(child: _buildWeeklyView(context, state.mealPlan, targets))
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Date Strip Scroller ──────────────────────────
                        SizedBox(height: AppSpacing.sm.h),
                        SizedBox(
                          height: 76.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _getWeekDays(selectedDate).map((day) {
                              final isSelected = day.day == selectedDate.day &&
                                  day.month == selectedDate.month &&
                                  day.year == selectedDate.year;

                              return Padding(
                                padding: EdgeInsets.only(right: AppSpacing.sm.w),
                                child: GestureDetector(
                                  onTap: () => context.read<PlannerCubit>().selectDate(day),
                                  child: Container(
                                    width: 64.w,
                                    decoration: BoxDecoration(
                                      color: isSelected ? scheme.primary : scheme.surfaceContainerLow,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: scheme.primary.withO(0.2),
                                                blurRadius: 8.r,
                                                offset: const Offset(0, 4),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          DateFormat('E').format(day),
                                          style: AppTextStyles.labelSm(context).copyWith(
                                            color: isSelected ? scheme.onPrimary : scheme.onSurfaceVariant,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          day.day.toString(),
                                          style: AppTextStyles.headlineSm(context).copyWith(
                                            color: isSelected ? scheme.onPrimary : scheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg.h),

                        // ── Macro Summary Bento Box ──────────────────────
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;

                            final calorieCard = GlassCard(
                              padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
                              borderRadius: BorderRadius.circular(24.r),
                              child: Center(
                                child: DonutChart(
                                  proteinRatio: totalProtein / (targets.protein > 0 ? targets.protein : 1),
                                  carbsRatio: totalCarbs / (targets.carbs > 0 ? targets.carbs : 1),
                                  fatRatio: totalFat / (targets.fat > 0 ? targets.fat : 1),
                                  centerText: remainingCalories > 0 ? remainingCalories.toString() : '0',
                                  centerLabel: remainingCalories > 0 ? 'kcal left' : 'Goal met',
                                  size: 140,
                                ),
                              ),
                            );

                            final progressBarsCard = GlassCard(
                              padding: EdgeInsets.all(AppSpacing.md.r),
                              borderRadius: BorderRadius.circular(24.r),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _MacroProgressRow(
                                    label: 'Protein',
                                    current: totalProtein,
                                    target: targets.protein,
                                    color: scheme.primary,
                                  ),
                                  SizedBox(height: AppSpacing.sm.h),
                                  _MacroProgressRow(
                                    label: 'Carbs',
                                    current: totalCarbs,
                                    target: targets.carbs,
                                    color: scheme.primaryContainer,
                                  ),
                                  SizedBox(height: AppSpacing.sm.h),
                                  _MacroProgressRow(
                                    label: 'Fat',
                                    current: totalFat,
                                    target: targets.fat,
                                    color: scheme.tertiary,
                                  ),
                                ],
                              ),
                            );

                            if (isWide) {
                              return Row(
                                children: [
                                  Expanded(flex: 4, child: calorieCard),
                                  SizedBox(width: AppSpacing.md.w),
                                  Expanded(flex: 6, child: progressBarsCard),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                calorieCard,
                                SizedBox(height: AppSpacing.md.h),
                                progressBarsCard,
                              ],
                            );
                          },
                        ),
                        SizedBox(height: AppSpacing.lg.h),

                        // ── Actions Row ──────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Meals Planned',
                              style: AppTextStyles.headlineSm(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => _openShoppingList(context, allDayRecipes),
                              icon: const Icon(Icons.shopping_bag_outlined),
                              label: const Text('Shopping List'),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md.h),

                        // ── Meal Slots ───────────────────────────────────
                        _MealSlotSection(
                          title: 'Breakfast',
                          icon: Icons.light_mode,
                          recipes: plan.breakfast,
                          onAdd: () => _navigateToAddRecipe(context, selectedDate, 'breakfast'),
                          onRemove: (id) => context.read<PlannerCubit>().removeRecipeFromPlan(selectedDate, 'breakfast', id),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        _MealSlotSection(
                          title: 'Lunch',
                          icon: Icons.wb_sunny,
                          recipes: plan.lunch,
                          onAdd: () => _navigateToAddRecipe(context, selectedDate, 'lunch'),
                          onRemove: (id) => context.read<PlannerCubit>().removeRecipeFromPlan(selectedDate, 'lunch', id),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        _MealSlotSection(
                          title: 'Dinner',
                          icon: Icons.nights_stay,
                          recipes: plan.dinner,
                          onAdd: () => _navigateToAddRecipe(context, selectedDate, 'dinner'),
                          onRemove: (id) => context.read<PlannerCubit>().removeRecipeFromPlan(selectedDate, 'dinner', id),
                        ),
                        SizedBox(height: AppSpacing.md.h),
                        _MealSlotSection(
                          title: 'Snacks',
                          icon: Icons.cookie,
                          recipes: plan.snacks,
                          onAdd: () => _navigateToAddRecipe(context, selectedDate, 'snacks'),
                          onRemove: (id) => context.read<PlannerCubit>().removeRecipeFromPlan(selectedDate, 'snacks', id),
                        ),
                        SizedBox(height: AppSpacing.xl.h * 2),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToAddRecipe(BuildContext context, DateTime date, String mealType) {
    // Navigate to Pantry flow to pick a recipe, pass plan parameters
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    context.push('/pantry/filter?planDate=$dateStr&mealType=$mealType');
  }

  Widget _buildWeeklyView(BuildContext context, List<MealPlan> plans, MacroTargets targets) {
    final scheme = context.color;
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin.w, vertical: AppSpacing.md.h),
      itemCount: plans.length,
      itemBuilder: (context, idx) {
        final plan = plans[idx];
        final allRecipes = [...plan.breakfast, ...plan.lunch, ...plan.dinner, ...plan.snacks];
        final dayCalories = allRecipes.fold<int>(0, (sum, r) => sum + r.calories);
        final ratio = (dayCalories / (targets.calories > 0 ? targets.calories : 1)).clamp(0.0, 1.0);

        return Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
          child: GlassCard(
            padding: EdgeInsets.all(AppSpacing.md.r),
            borderRadius: BorderRadius.circular(16.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMM').format(plan.date),
                      style: AppTextStyles.labelMd(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$dayCalories / ${targets.calories} kcal',
                      style: AppTextStyles.labelSm(context).copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100.w,
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: scheme.surfaceContainerHighest,
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MacroProgressRow extends StatelessWidget {
  const _MacroProgressRow({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
  });

  final String label;
  final int current;
  final int target;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final ratio = (current / (target > 0 ? target : 1)).clamp(0.0, 1.0);
    final isNearing = ratio > 0.9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: AppTextStyles.labelMd(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '$current / ${target}g',
              style: AppTextStyles.labelSm(context).copyWith(
                color: isNearing ? scheme.error : scheme.onSurfaceVariant,
                fontWeight: isNearing ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: scheme.surfaceContainerHighest,
            color: color,
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }
}

class _MealSlotSection extends StatelessWidget {
  const _MealSlotSection({
    required this.title,
    required this.icon,
    required this.recipes,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final IconData icon;
  final List<Recipe> recipes;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = context.color;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: scheme.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm.h),
        if (recipes.isEmpty)
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h),
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant, style: BorderStyle.none), // dashed emulation
                borderRadius: BorderRadius.circular(16.r),
                color: scheme.surfaceContainerLow,
              ),
              child: Column(
                children: [
                  Icon(Icons.add_circle_outline, color: scheme.outline, size: 28.sp),
                  SizedBox(height: 4.h),
                  Text(
                    'Add $title Recipe',
                    style: AppTextStyles.labelMd(context).copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: recipes.map((recipe) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm.h),
                child: GlassCard(
                  padding: EdgeInsets.all(AppSpacing.sm.r),
                  borderRadius: BorderRadius.circular(16.r),
                  child: Row(
                    children: [
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(recipe.imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe.title,
                              style: AppTextStyles.labelMd(context).copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Wrap(
                              spacing: 8.w,
                              children: [
                                Text('${recipe.calories} kcal', style: TextStyle(fontSize: 10.sp, color: scheme.onSurfaceVariant)),
                                Text('${recipe.protein}g P', style: TextStyle(fontSize: 10.sp, color: scheme.primary)),
                                Text('${recipe.carbs}g C', style: TextStyle(fontSize: 10.sp, color: scheme.primaryContainer)),
                                Text('${recipe.fat}g F', style: TextStyle(fontSize: 10.sp, color: scheme.tertiary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: onAdd,
                        tooltip: 'Swap Recipe',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: scheme.error),
                        onPressed: () => onRemove(recipe.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
