import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../theme/app_text_styles.dart';

/// Macro type for colour coding.
enum MacroType { protein, carbs, fat }

/// Small pill-shaped chip showing a macro value, e.g. "45g P".
///
/// Colour-coded per Stitch:
/// - **Protein** → primaryContainer tones
/// - **Carbs** → tertiaryContainer tones
/// - **Fat** → secondary/secondaryContainer tones
class MacroChip extends StatelessWidget {
  const MacroChip({
    super.key,
    required this.grams,
    required this.label,
    required this.type,
  });

  final int grams;
  final String label;
  final MacroType type;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (Color bg, Color fg) = switch (type) {
      MacroType.protein => (
          scheme.primaryContainer.withO(0.2),
          scheme.primaryContainer,
        ),
      MacroType.carbs => (
          scheme.tertiaryContainer.withO(0.1),
          scheme.tertiaryContainer,
        ),
      MacroType.fat => (
          scheme.secondaryContainer.withO(0.2),
          scheme.secondary,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        '${grams}g $label',
        style: AppTextStyles.labelSm(context).copyWith(
          color: fg,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
