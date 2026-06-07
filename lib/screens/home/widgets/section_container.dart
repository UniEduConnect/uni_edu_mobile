import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';

/// Wraps a section's content with vertical rhythm, horizontal page padding and
/// a max content width (so it stays readable on tablets). Optional background.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.background,
    this.gradient,
    this.verticalPadding = AppDimens.sectionGap,
  });

  final Widget child;
  final Color? background;
  final Gradient? gradient;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: background, gradient: gradient),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.pagePadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
