/// Shared spacing, radius and layout constants.
///
/// Using these instead of magic numbers keeps padding, corner radius and
/// section rhythm consistent across every screen.
class AppDimens {
  AppDimens._();

  // Corner radius
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusPill = 999;

  // Spacing scale
  static const double gapXs = 4;
  static const double gapSm = 8;
  static const double gapMd = 16;
  static const double gapLg = 24;
  static const double gapXl = 40;

  // Layout
  static const double pagePadding = 20;
  static const double sectionGap = 56;
  static const double maxContentWidth = 1200;
}
