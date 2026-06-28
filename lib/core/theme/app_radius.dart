import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Border radius presets derived from the Stitch shape tokens.
///
/// All values use ScreenUtil `.r` for responsive adaptation.
abstract final class AppRadius {
  static BorderRadius get sm => BorderRadius.circular(4.r);
  static BorderRadius get regular => BorderRadius.circular(8.r);
  static BorderRadius get md => BorderRadius.circular(12.r);
  static BorderRadius get lg => BorderRadius.circular(16.r);
  static BorderRadius get xl => BorderRadius.circular(24.r);
  static BorderRadius get full => BorderRadius.circular(9999.r);

  // Raw double values for custom shapes
  static double get smValue => 4.r;
  static double get regularValue => 8.r;
  static double get mdValue => 12.r;
  static double get lgValue => 16.r;
  static double get xlValue => 24.r;
  static double get fullValue => 9999.r;
}
