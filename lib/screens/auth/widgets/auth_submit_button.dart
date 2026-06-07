import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

/// Full-width pill submit button with a loading state, shared by the auth
/// forms. Shows a spinner + [loadingLabel] while [loading] is true and is
/// disabled so the form can't be double-submitted.
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
    this.loadingLabel = 'Đang xử lý...',
  });

  final String label;
  final bool loading;
  final VoidCallback onPressed;
  final String loadingLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          ),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryForeground,
                    ),
                  ),
                  const SizedBox(width: AppDimens.gapSm),
                  Text(loadingLabel),
                ],
              )
            : Text(label),
      ),
    );
  }
}
