import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'macro_chip.dart';

/// A recipe card matching the Stitch "Today's Recommendations" carousel card.
///
/// Features:
/// - Food image with hover/tap scale animation
/// - Star-rating badge overlay
/// - Title + description
/// - Macro chips row (P / C / F)
/// - Cook-time indicator
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.cookTime,
    required this.proteinLabel,
    required this.carbsLabel,
    required this.fatLabel,
    this.onTap,
  });

  final String title;
  final String description;
  final String imageUrl;
  final double rating;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final String cookTime;
  final String proteinLabel;
  final String carbsLabel;
  final String fatLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: scheme.surfaceContainerHighest),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withO(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image ──────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.r),
              ),
              child: SizedBox(
                height: 160.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        color: scheme.surfaceContainerHigh,
                        child: Icon(
                          Icons.restaurant,
                          size: 48.sp,
                          color: scheme.outlineVariant,
                        ),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surface.withO(0.9),
                          borderRadius: BorderRadius.circular(999.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withO(0.1),
                              blurRadius: 4.r,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 14.sp,
                              color: scheme.secondary,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              rating.toStringAsFixed(1),
                              style: AppTextStyles.labelSm(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.all(AppSpacing.sm.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMd(context),
                  ),
                  SizedBox(height: AppSpacing.xs.h),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMd(context).copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Macros + Cook time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          MacroChip(
                            grams: proteinGrams,
                            label: proteinLabel,
                            type: MacroType.protein,
                          ),
                          SizedBox(width: 4.w),
                          MacroChip(
                            grams: carbsGrams,
                            label: carbsLabel,
                            type: MacroType.carbs,
                          ),
                          SizedBox(width: 4.w),
                          MacroChip(
                            grams: fatGrams,
                            label: fatLabel,
                            type: MacroType.fat,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16.sp,
                            color: scheme.outline,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            cookTime,
                            style: AppTextStyles.labelSm(context),
                          ),
                        ],
                      ),
                    ],
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
