import 'package:flutter/material.dart';

import '../core/theme/app_dimens.dart';
import '../core/theme/app_text_styles.dart';
import '../models/subject.dart';
import 'soft_card.dart';

/// Compact, centered card for one subject in the "Môn học" grid.
class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key, required this.subject, this.onTap});

  final Subject subject;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: subject.gradient,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: subject.gradient.last.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(subject.icon, size: 26, color: Colors.white),
          ),
          const SizedBox(height: AppDimens.gapMd),
          Text(
            subject.name,
            textAlign: TextAlign.center,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subject.gradeRange,
            textAlign: TextAlign.center,
            style: AppTextStyles.statLabel,
          ),
        ],
      ),
    );
  }
}
