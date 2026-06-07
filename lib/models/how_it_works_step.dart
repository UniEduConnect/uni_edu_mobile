import 'package:flutter/material.dart';

/// One step in the "Cách hoạt động" flow (for either tutors or students).
class HowItWorksStep {
  const HowItWorksStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
}

/// Which audience the how-it-works steps are shown for.
enum HowItWorksAudience { tutor, student }
