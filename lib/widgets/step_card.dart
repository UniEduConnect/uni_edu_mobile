import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../models/how_it_works_step.dart';
import 'soft_card.dart';

/// Card for a single step in the "Cách hoạt động" flow, with a large faded
/// step number watermark in the corner.
class StepCard extends StatelessWidget {
  const StepCard({super.key, required this.step});

  final HowItWorksStep step;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Stack(
        children: [
          Positioned(
            top: -6,
            right: 0,
            child: Text(
              step.number,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Color(0x141D4FD7), // primary @ ~8% opacity
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.neon.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                child: Icon(step.icon, size: 24, color: AppColors.neon),
              ),
              const SizedBox(height: AppDimens.gapMd),
              Text(step.title, style: AppTextStyles.cardTitle),
              const SizedBox(height: AppDimens.gapXs),
              Flexible(
                child: Text(
                  step.description,
                  style: AppTextStyles.cardBody,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
