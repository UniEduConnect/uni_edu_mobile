import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/soft_card.dart';

/// Shared page chrome for the auth screens: a UNI-EDU app bar, a centered
/// title block with an optional icon, and a [SoftCard] holding the form.
///
/// Keeps the login / register screens visually consistent with each other and
/// with the web frontend's centered-card auth pages.
class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.headerIcon,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData? headerIcon;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('UNI', style: AppTextStyles.cardTitle),
            GradientText(
              'EDU',
              style: AppTextStyles.cardTitle,
              gradient: AppColors.brandGradient,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pagePadding,
            AppDimens.gapXl,
            AppDimens.pagePadding,
            AppDimens.gapXl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (headerIcon != null) ...[
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                      ),
                      child: Icon(headerIcon, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(height: AppDimens.gapMd),
                  ],
                  Text(title, style: AppTextStyles.sectionTitle, textAlign: TextAlign.center),
                  const SizedBox(height: AppDimens.gapXs),
                  Text(
                    subtitle,
                    style: AppTextStyles.sectionSubtitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppDimens.gapLg),
                  SoftCard(
                    padding: const EdgeInsets.all(AppDimens.gapLg),
                    child: child,
                  ),
                  if (footer != null) ...[
                    const SizedBox(height: AppDimens.gapLg),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
