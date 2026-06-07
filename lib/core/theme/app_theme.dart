import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the global [ThemeData]. Configured once and passed to [MaterialApp]
/// so colors, the app bar and buttons look the same everywhere.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      surface: AppColors.card,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        foregroundColor: AppColors.foreground,
        centerTitle: false,
      ),
    );
  }
}
