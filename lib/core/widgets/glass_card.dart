import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';
import '../theme/app_radius.dart';

/// A glassmorphism container matching the Stitch "Glass Card" spec.
///
/// Light mode: `rgba(255,255,255,0.7)` + blur(12) + white border.
/// Dark mode: `rgba(255,255,255,0.08)` + blur(12) + subtle border.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.blurSigma = 12,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? AppRadius.xl;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withO(0.08)
                : Colors.white.withO(0.7),
            borderRadius: radius,
            border: Border.all(
              color: isDark
                  ? Colors.white.withO(0.1)
                  : Colors.white.withO(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F5238).withO(0.05),
                blurRadius: 32.r,
                offset: Offset(0, 8.h),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
