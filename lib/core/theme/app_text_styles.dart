import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Reusable text styles. Centralizing them keeps typography consistent
/// (see the "Thiết kế UI nhất quán" guideline).
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    height: 1.15,
    letterSpacing: -0.5,
    color: AppColors.deepBlue,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.3,
    color: AppColors.foreground,
  );

  static const TextStyle sectionSubtitle = TextStyle(
    fontSize: 15,
    height: 1.5,
    color: AppColors.mutedForeground,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.foreground,
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 13,
    height: 1.45,
    color: AppColors.mutedForeground,
  );

  static const TextStyle badge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bullet = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.foreground,
  );

  static const TextStyle statValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w900,
    color: AppColors.deepBlue,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    color: AppColors.mutedForeground,
  );
}
