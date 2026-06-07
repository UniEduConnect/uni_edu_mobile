/// Small helpers for responsive layout so grids adapt to phones, large phones
/// and tablets (see the "Thiết kế layout responsive" guideline).
class Responsive {
  Responsive._();

  static const double tabletBreakpoint = 700;
  static const double desktopBreakpoint = 1100;

  /// Number of grid columns based on the available width.
  static int columns(
    double width, {
    int phone = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (width >= desktopBreakpoint) return desktop;
    if (width >= tabletBreakpoint) return tablet;
    return phone;
  }

  static bool isTablet(double width) => width >= tabletBreakpoint;
}
