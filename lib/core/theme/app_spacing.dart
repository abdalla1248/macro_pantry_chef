/// Spacing constants derived from the Stitch design system.
///
/// Apply ScreenUtil extensions (`.w`, `.h`) at the call-site:
/// ```dart
/// EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin.w)
/// SizedBox(height: AppSpacing.md.h)
/// ```
abstract final class AppSpacing {
  static const double xs = 4;
  static const double base = 8;
  static const double sm = 12;
  static const double gutter = 16;
  static const double containerMargin = 20;
  static const double md = 24;
  static const double lg = 40;
  static const double xl = 64;
}
