import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/gradient_text.dart';
import '../../auth/register_screen.dart';
import '../../auth/register_tutor_screen.dart';
import 'section_container.dart';

/// Top hero of the home page: tagline, headline, value bullets, CTAs and stats.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  static const _bullets = [
    'Gia sư được kiểm tra năng lực',
    'AI hỗ trợ đánh giá học tập',
    'Thanh toán an toàn, minh bạch',
  ];

  static const _stats = [
    (_StatData(Icons.groups_outlined, '1,200+', 'Gia sư & Giáo viên')),
    (_StatData(Icons.school_outlined, '890+', 'Học sinh')),
    (_StatData(Icons.thumb_up_outlined, '98%', 'Hài lòng')),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      gradient: AppColors.heroGradient,
      verticalPadding: 36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tagline pill with a pulsing-style status dot.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimens.gapSm),
                Text(
                  'Nền tảng giáo dục hàng đầu Việt Nam',
                  style: AppTextStyles.badge.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.gapLg),

          // Headline (the middle line uses the brand gradient).
          const Text('Kết nối', style: AppTextStyles.display),
          GradientText(
            'Gia sư chất lượng',
            style: AppTextStyles.display,
            gradient: AppColors.brandGradient,
          ),
          const Text('với Học sinh', style: AppTextStyles.display),
          const SizedBox(height: AppDimens.gapLg),

          // Value bullets.
          ..._bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.gapSm + 2),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 20, color: AppColors.success),
                  const SizedBox(width: AppDimens.gapSm + 2),
                  Expanded(child: Text(b, style: AppTextStyles.bullet)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimens.gapMd),

          // Calls to action.
          Wrap(
            spacing: AppDimens.gapMd,
            runSpacing: AppDimens.gapSm,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primaryForeground,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  ),
                  textStyle: AppTextStyles.button,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tìm gia sư ngay'),
                    SizedBox(width: AppDimens.gapSm),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary.withValues(alpha: 0.30)),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                  ),
                  textStyle: AppTextStyles.button,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterTutorScreen()),
                ),
                child: const Text('Đăng ký làm gia sư'),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.gapXl),

          // Stat chips.
          Wrap(
            spacing: AppDimens.gapMd,
            runSpacing: AppDimens.gapMd,
            children: _stats.map((s) => _StatChip(data: s)).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.data});
  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(data.label, style: AppTextStyles.statLabel),
            ],
          ),
          const SizedBox(height: 2),
          Text(data.value, style: AppTextStyles.statValue),
        ],
      ),
    );
  }
}
