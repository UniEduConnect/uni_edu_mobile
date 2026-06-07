import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../home_section.dart';

/// Bottom footer: brand block, contact info, link groups and copyright.
///
/// The "Khám phá" group jumps to the page sections via [onSectionTap];
/// the other links are placeholders until those routes exist.
class FooterSection extends StatelessWidget {
  const FooterSection({super.key, required this.onSectionTap});

  final ValueChanged<HomeSection> onSectionTap;

  static const Color _fg = Colors.white;

  @override
  Widget build(BuildContext context) {
    final muted = _fg.withValues(alpha: 0.70);

    return Container(
      width: double.infinity,
      color: AppColors.deepBlue,
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.gapXl,
        horizontal: AppDimens.pagePadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand + description + contact.
              Row(
                children: [
                  const Text(
                    'UNI',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _fg,
                    ),
                  ),
                  Text(
                    'EDU',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.neon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.gapMd),
              Text(
                'Nền tảng kết nối gia sư và học sinh hàng đầu Việt Nam với công nghệ AI tiên tiến.',
                style: TextStyle(fontSize: 13, height: 1.5, color: muted),
              ),
              const SizedBox(height: AppDimens.gapMd),
              _ContactRow(icon: Icons.mail_outline, text: 'support@uni-edu.vn', color: muted),
              const SizedBox(height: AppDimens.gapSm),
              _ContactRow(icon: Icons.phone_outlined, text: '1900 1234', color: muted),
              const SizedBox(height: AppDimens.gapXl),

              // Link groups — wrap so they reflow on narrow screens.
              Wrap(
                spacing: AppDimens.gapXl,
                runSpacing: AppDimens.gapLg,
                children: [
                  _LinkGroup(
                    title: 'Khám phá',
                    links: [
                      for (final s in HomeSection.values)
                        _FooterLink(s.label, () => onSectionTap(s)),
                    ],
                  ),
                  const _LinkGroup(
                    title: 'Sản phẩm',
                    links: [
                      _FooterLink('Tìm gia sư', null),
                      _FooterLink('Đăng ký làm gia sư', null),
                      _FooterLink('Thi thử online', null),
                      _FooterLink('Bảng giá', null),
                    ],
                  ),
                  const _LinkGroup(
                    title: 'Hỗ trợ',
                    links: [
                      _FooterLink('Trung tâm trợ giúp', null),
                      _FooterLink('Câu hỏi thường gặp', null),
                      _FooterLink('Liên hệ', null),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.gapXl),

              Divider(color: _fg.withValues(alpha: 0.20)),
              const SizedBox(height: AppDimens.gapMd),
              Center(
                child: Text(
                  '© 2025 UNI-EDU. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: _fg.withValues(alpha: 0.60)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppDimens.gapSm),
        Text(text, style: TextStyle(fontSize: 13, color: color)),
      ],
    );
  }
}

class _LinkGroup extends StatelessWidget {
  const _LinkGroup({required this.title, required this.links});

  final String title;
  final List<_FooterLink> links;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimens.gapMd),
        ...links,
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink(this.label, this.onTap);

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.gapSm + 4),
      child: InkWell(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.70),
          ),
        ),
      ),
    );
  }
}
