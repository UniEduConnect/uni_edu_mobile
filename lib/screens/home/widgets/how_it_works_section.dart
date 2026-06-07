import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/home_content.dart';
import '../../../models/how_it_works_step.dart';
import '../../../widgets/section_heading.dart';
import '../../../widgets/step_card.dart';
import 'section_container.dart';

/// "Cách hoạt động" — toggles between the tutor and student flows.
/// Stateful because the selected audience tab is local UI state.
class HowItWorksSection extends StatefulWidget {
  const HowItWorksSection({super.key});

  @override
  State<HowItWorksSection> createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection> {
  HowItWorksAudience _audience = HowItWorksAudience.tutor;

  @override
  Widget build(BuildContext context) {
    final steps = HomeContent.stepsFor(_audience);

    return SectionContainer(
      gradient: AppColors.heroGradient,
      child: Column(
        children: [
          const SectionHeading(
            title: 'Cách',
            highlight: 'hoạt động',
            subtitle: 'Quy trình đơn giản, minh bạch cho cả gia sư và học sinh',
          ),
          const SizedBox(height: AppDimens.gapLg),

          // Audience toggle.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AudienceTab(
                label: 'Dành cho Gia sư',
                selected: _audience == HowItWorksAudience.tutor,
                onTap: () => _select(HowItWorksAudience.tutor),
              ),
              const SizedBox(width: AppDimens.gapSm),
              _AudienceTab(
                label: 'Dành cho Học sinh',
                selected: _audience == HowItWorksAudience.student,
                onTap: () => _select(HowItWorksAudience.student),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.gapXl),

          LayoutBuilder(
            builder: (context, constraints) {
              final columns = Responsive.columns(
                constraints.maxWidth,
                phone: 1,
                tablet: 2,
                desktop: 4,
              );
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppDimens.gapMd,
                  mainAxisSpacing: AppDimens.gapMd,
                  mainAxisExtent: 180,
                ),
                itemBuilder: (context, index) => StepCard(step: steps[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  void _select(HowItWorksAudience audience) {
    if (_audience != audience) setState(() => _audience = audience);
  }
}

class _AudienceTab extends StatelessWidget {
  const _AudienceTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.card,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(
              fontSize: 14,
              color: selected ? AppColors.primaryForeground : AppColors.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
