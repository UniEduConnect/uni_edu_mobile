import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import 'gradient_text.dart';

/// Centered heading used at the top of each landing section: a small colored
/// pill, a two-part title (plain + gradient highlight) and a subtitle.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.badge,
    this.badgeColor = AppColors.primary,
    required this.title,
    required this.highlight,
    required this.subtitle,
  });

  final String? badge;
  final Color badgeColor;
  final String title;
  final String highlight;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
            ),
            child: Text(
              badge!,
              style: AppTextStyles.badge.copyWith(color: badgeColor),
            ),
          ),
          const SizedBox(height: AppDimens.gapMd),
        ],
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('$title ', style: AppTextStyles.sectionTitle),
            GradientText(
              highlight,
              style: AppTextStyles.sectionTitle,
              gradient: AppColors.brandGradient,
            ),
          ],
        ),
        const SizedBox(height: AppDimens.gapSm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionSubtitle,
          ),
        ),
      ],
    );
  }
}
