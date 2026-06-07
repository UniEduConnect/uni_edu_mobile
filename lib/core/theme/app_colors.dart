import 'package:flutter/material.dart';

/// Central color palette for the UNI-EDU app.
///
/// Values are converted from the web frontend design tokens
/// (`UNI-EDU-Frontend-V2/src/index.css`) so the mobile UI stays on-brand.
/// Keep every color here — do not hard-code `Color(0x...)` in widgets.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF1D4FD7); // hsl(224 76% 48%)
  static const Color primaryForeground = Color(0xFFFFFFFF);
  static const Color deepBlue = Color(0xFF052861); // hsl(217 91% 20%)
  static const Color neon = Color(0xFF1E79F1); // hsl(214 88% 53%)
  static const Color info = Color(0xFF1E79F1);

  // Surfaces
  static const Color background = Color(0xFFF8FAFC); // hsl(210 40% 98%)
  static const Color card = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFFE0EEFF); // hsl(214 100% 94%)
  static const Color heroTop = Color(0xFFEBF4FE); // overview-surface
  static const Color heroBottom = Color(0xFFF5FAFF); // hsl(210 100% 98%)

  // Text
  static const Color foreground = Color(0xFF0F1729); // hsl(222 47% 11%)
  static const Color mutedForeground = Color(0xFF657593); // hsl(215 16% 47%)

  // Status
  static const Color success = Color(0xFF21C45D); // hsl(142 71% 45%)
  static const Color warning = Color(0xFFF59F0A); // hsl(38 92% 50%)

  // Lines
  static const Color border = Color(0xFFE1E7EF); // hsl(214 32% 91%)

  /// Brand gradient used for highlighted text and accents.
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, info],
  );

  /// Soft top-to-bottom background used by the hero / how-it-works sections.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [heroTop, background],
  );
}
