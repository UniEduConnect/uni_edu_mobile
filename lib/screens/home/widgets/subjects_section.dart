import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/home_content.dart';
import '../../../widgets/section_heading.dart';
import '../../../widgets/subject_card.dart';
import 'section_container.dart';

/// "12 môn học cơ bản" — grid of subjects.
class SubjectsSection extends StatelessWidget {
  const SubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.background,
      child: Column(
        children: [
          const SectionHeading(
            badge: 'Chương trình học',
            badgeColor: AppColors.neon,
            title: '12 môn học',
            highlight: 'cơ bản',
            subtitle:
                'Đầy đủ các môn học theo chương trình phổ thông, từ lớp 1 đến lớp 12',
          ),
          const SizedBox(height: AppDimens.gapXl),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = Responsive.columns(
                constraints.maxWidth,
                phone: 2,
                tablet: 4,
                desktop: 6,
              );
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: HomeContent.subjects.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: AppDimens.gapMd,
                  mainAxisSpacing: AppDimens.gapMd,
                  mainAxisExtent: 150,
                ),
                itemBuilder: (context, index) =>
                    SubjectCard(subject: HomeContent.subjects[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
