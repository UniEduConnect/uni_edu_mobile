import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/home_content.dart';
import '../../../widgets/feature_card.dart';
import '../../../widgets/section_heading.dart';
import 'section_container.dart';

/// "Tính năng nổi bật" — grid of platform features.
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.background,
      child: Column(
        children: [
          const SectionHeading(
            badge: 'Tính năng',
            title: 'Tính năng',
            highlight: 'nổi bật',
            subtitle: 'Hệ thống quản lý học tập toàn diện với công nghệ AI tiên tiến',
          ),
          const SizedBox(height: AppDimens.gapXl),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = Responsive.columns(constraints.maxWidth);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: HomeContent.features.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppDimens.gapMd,
                  mainAxisSpacing: AppDimens.gapMd,
                  mainAxisExtent: 190, // fixed height avoids RenderFlex overflow
                ),
                itemBuilder: (context, index) =>
                    FeatureCard(feature: HomeContent.features[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
