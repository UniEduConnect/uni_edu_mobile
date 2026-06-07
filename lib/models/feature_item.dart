import 'package:flutter/material.dart';

/// A single highlighted platform feature shown in the "Tính năng" section.
class FeatureItem {
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String description;

  /// Accent color for the icon badge (background uses a faded version of it).
  final Color accent;
}
