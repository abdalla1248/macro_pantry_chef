import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../theme/app_radius.dart';

/// A quantity stepper widget: [−] value [+] matching Stitch design.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.unit,
    required this.onIncrement,
    required this.onDecrement,
  });

  final double value;
  final String unit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  String get _formattedValue {
    if (value == value.roundToDouble()) {
      return '${value.toInt()} $unit';
    }
    return '${value.toStringAsFixed(1)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.regular,
        border: Border.all(
          color: scheme.outlineVariant.withO(0.5),
        ),
      ),
      padding: EdgeInsets.all(4.r),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          _StepperButton(
            icon: Icons.remove,
            onPressed: onDecrement,
          ),
          // Value display
          SizedBox(
            width: 64.w,
            child: Text(
              _formattedValue,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurface,
                  ),
            ),
          ),
          // Increase button
          _StepperButton(
            icon: Icons.add,
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6.r),
        child: SizedBox(
          width: 32.w,
          height: 32.h,
          child: Icon(
            icon,
            size: 20.sp,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
