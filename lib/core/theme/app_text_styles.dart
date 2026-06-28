import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Named text style accessors matching Stitch typography tokens.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTextStyles.headlineMd(context));
/// ```
abstract final class AppTextStyles {
  /// display-lg-mobile — Plus Jakarta Sans 32/38 Bold
  static TextStyle displayLgMobile(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 38 / 32,
        letterSpacing: -0.02 * 32.sp,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// headline-md — Plus Jakarta Sans 24/32 SemiBold
  static TextStyle headlineMd(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// headline-sm — Plus Jakarta Sans 20/28 SemiBold
  static TextStyle headlineSm(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// body-lg — Inter 18/28 Regular
  static TextStyle bodyLg(BuildContext context) => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// body-md — Inter 16/24 Regular
  static TextStyle bodyMd(BuildContext context) => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// label-md — Inter 14/20 Medium
  static TextStyle labelMd(BuildContext context) => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.01 * 14.sp,
        color: Theme.of(context).colorScheme.onSurface,
      );

  /// label-sm — Inter 12/16 SemiBold
  static TextStyle labelSm(BuildContext context) => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
