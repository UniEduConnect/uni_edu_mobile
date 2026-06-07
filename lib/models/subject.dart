import 'package:flutter/material.dart';

/// A school subject shown in the "Môn học" grid.
class Subject {
  const Subject({
    required this.icon,
    required this.name,
    required this.gradeRange,
    required this.gradient,
  });

  final IconData icon;
  final String name;
  final String gradeRange;

  /// Two-color gradient for the subject's icon badge.
  final List<Color> gradient;
}
