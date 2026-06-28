import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_spacing.dart';
import 'glass_card.dart';

/// A glass card with icon, title, description, value display, and a range slider.
///
/// Used in the Macro Filter screen for Protein, Carbs, Fat, Calories targeting.
class MacroSliderCard extends StatelessWidget {
  const MacroSliderCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.valueColor,
    required this.unit,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
    this.showBorderAccent = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final double value;
  final Color valueColor;
  final String unit;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final double step;
  final bool showBorderAccent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GlassCard(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Header row: icon + title/subtitle ... value
          Row(
            children: [
              // Icon container
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: AppSpacing.sm),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.headlineSmall?.copyWith(
                        color: scheme.onSurface,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Value display
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.round().toString(),
                    style: textTheme.displayLarge?.copyWith(
                      color: valueColor,
                      fontSize: 32.sp,
                      height: 1,
                    ),
                  ),
                  Text(
                    unit,
                    style: textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSpacing.gutter),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: scheme.primary,
              inactiveTrackColor: scheme.surfaceContainerHighest,
              thumbColor: scheme.surface,
              overlayColor: scheme.primary.withValues(alpha: 0.1),
              thumbShape: _ThumbShape(scheme.primary),
              trackHeight: 4.h,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: ((max - min) / step).round(),
              onChanged: onChanged,
            ),
          ),
          // Min/max labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${min.round()}${unit == 'kcal' ? '' : unit}',
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
                Text(
                  '${max.round()}${unit == 'kcal' ? '' : unit}',
                  style: textTheme.labelSmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom thumb that matches the Stitch design:
/// white circle with a primary border and soft shadow.
class _ThumbShape extends SliderComponentShape {
  _ThumbShape(this.borderColor);

  final Color borderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(24.r, 24.r);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final radius = 12.r;

    // Shadow
    canvas.drawCircle(
      center + Offset(0, 2.r),
      radius,
      Paint()
        ..color = borderColor.withValues(alpha: 0.2)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.r),
    );

    // White fill
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = Colors.white,
    );

    // Primary border
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.r,
    );
  }
}
