import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'glass_card.dart';
import 'quantity_stepper.dart';

/// A pantry inventory item card matching the Stitch "My Pantry" design.
///
/// Displays ingredient image, name, macro chips, low-stock badge,
/// and a quantity stepper.
class PantryItemCard extends StatelessWidget {
  const PantryItemCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.isLow = false,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String name;
  final String imageUrl;
  final double quantity;
  final String unit;
  final double protein;
  final double carbs;
  final double fat;
  final bool isLow;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      borderRadius: AppRadius.xl,
      padding: EdgeInsets.all(AppSpacing.gutter),
      child: Row(
        children: [
          // Ingredient image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 64.w,
              height: 64.h,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.restaurant,
                    color: scheme.outline,
                    size: 28.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.gutter),
          // Name + macro chips
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.headlineSmall?.copyWith(
                    color: scheme.onSurface,
                    fontSize: 18.sp,
                  ),
                ),
                if (isLow)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(
                      'Running low',
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.error,
                      ),
                    ),
                  )
                else
                  _buildMacroRow(context),
              ],
            ),
          ),
          // Quantity stepper
          QuantityStepper(
            value: quantity,
            unit: unit,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final chips = <Widget>[];

    if (protein > 0) {
      chips.add(_MiniMacroChip(
        label: '${protein.toStringAsFixed(0)}g P',
        dotColor: scheme.primary,
        textColor: scheme.primary,
      ));
    }
    if (carbs > 0) {
      chips.add(_MiniMacroChip(
        label: '${carbs.toStringAsFixed(0)}g C',
        dotColor: scheme.secondaryContainer,
        textColor: scheme.onSurfaceVariant,
      ));
    }
    if (fat > 0) {
      chips.add(_MiniMacroChip(
        label: '${fat.toStringAsFixed(1)}g F',
        dotColor: scheme.secondary,
        textColor: scheme.onSurfaceVariant,
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Wrap(spacing: 6.w, children: chips),
    );
  }
}

class _MiniMacroChip extends StatelessWidget {
  const _MiniMacroChip({
    required this.label,
    required this.dotColor,
    required this.textColor,
  });

  final String label;
  final Color dotColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: const Color(0xFF0F5238).withO(0.1),
        ),
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
          SizedBox(width: 4.w),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                ),
          ),
        ],
      ),
    );
  }
}
