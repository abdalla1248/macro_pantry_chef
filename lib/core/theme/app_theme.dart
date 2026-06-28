import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Application [ThemeData] for light and dark modes.
///
/// Typography uses **Plus Jakarta Sans** for headlines and
/// **Inter** for body / label text — matching the Stitch design system.
abstract final class AppTheme {
  // ── Light Theme ────────────────────────────────────────────────────
  static ThemeData get lightTheme => _buildTheme(AppColors.lightScheme);

  // ── Dark Theme ─────────────────────────────────────────────────────
  static ThemeData get darkTheme => _buildTheme(AppColors.darkScheme);

  // ── Builder ────────────────────────────────────────────────────────
  static ThemeData _buildTheme(ColorScheme scheme) {
    final textTheme = TextTheme(
      // display-lg-mobile
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        height: 38 / 32,
        letterSpacing: -0.02 * 32.sp,
        color: scheme.onSurface,
      ),
      // headline-md
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        color: scheme.onSurface,
      ),
      // headline-sm
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: scheme.onSurface,
      ),
      // body-lg
      bodyLarge: GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        color: scheme.onSurface,
      ),
      // body-md
      bodyMedium: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        color: scheme.onSurface,
      ),
      // label-md
      labelLarge: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.01 * 14.sp,
        color: scheme.onSurface,
      ),
      // label-sm
      labelSmall: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        color: scheme.onSurface,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          height: 32 / 24,
          color: scheme.primary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999.r),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: scheme.onSurfaceVariant,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
