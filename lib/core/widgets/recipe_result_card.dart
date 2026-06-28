import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../theme/app_spacing.dart';
import 'glass_card.dart';

/// A recipe card for the Results grid — glass card with image, missing badge,
/// title, kcal, macro chips, cook time, and difficulty.
class RecipeResultCard extends StatelessWidget {
  const RecipeResultCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.cookTimeMinutes,
    required this.difficulty,
    this.missingCount = 0,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int cookTimeMinutes;
  final String difficulty;
  final int missingCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: BorderRadius.circular(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with missing ingredient badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.restaurant,
                          color: scheme.outline,
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                // Missing badge
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surface.withO(0.9),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          missingCount == 0
                              ? Icons.check_circle
                              : Icons.error,
                          size: 16.sp,
                          color: missingCount == 0
                              ? scheme.primary
                              : scheme.secondary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          '$missingCount missing',
                          style: textTheme.labelSmall?.copyWith(
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content area
            Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + kcal
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            color: scheme.onSurface,
                            fontSize: 18.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer.withO(0.3),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          '$calories kcal',
                          style: textTheme.labelLarge?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  // Macro chips
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      _MacroChip(
                        label: '${protein}g Pro',
                        dotColor: scheme.primary,
                        scheme: scheme,
                        textTheme: textTheme,
                      ),
                      _MacroChip(
                        label: '${carbs}g Carb',
                        dotColor: scheme.secondaryContainer,
                        scheme: scheme,
                        textTheme: textTheme,
                      ),
                      _MacroChip(
                        label: '${fat}g Fat',
                        dotColor: const Color(0xFFFBBC04),
                        scheme: scheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Footer: time + difficulty
                  Container(
                    padding: EdgeInsets.only(top: AppSpacing.sm),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: scheme.outlineVariant.withO(0.3),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 16.sp,
                                color: scheme.onSurfaceVariant),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              '$cookTimeMinutes min',
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              difficulty == 'Easy'
                                  ? Icons.signal_cellular_alt
                                  : Icons.signal_cellular_alt_2_bar,
                              size: 16.sp,
                              color: scheme.onSurfaceVariant,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Text(
                              difficulty,
                              style: textTheme.labelSmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({
    required this.label,
    required this.dotColor,
    required this.scheme,
    required this.textTheme,
  });

  final String label;
  final Color dotColor;
  final ColorScheme scheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.white.withO(0.5),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withO(0.8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
