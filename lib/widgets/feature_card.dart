import 'package:flutter/material.dart';

import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../models/feature_item.dart';
import 'soft_card.dart';

/// Card for a single feature in the "Tính năng" grid.
class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.feature});

  final FeatureItem feature;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: feature.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            ),
            child: Icon(feature.icon, size: 24, color: feature.accent),
          ),
          const SizedBox(height: AppDimens.gapMd),
          Text(feature.title, style: AppTextStyles.cardTitle),
          const SizedBox(height: AppDimens.gapXs),
          // Flexible + maxLines guards against overflow in the fixed-height cell.
          Flexible(
            child: Text(
              feature.description,
              style: AppTextStyles.cardBody,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
