import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/gradient_text.dart';
import 'home_section.dart';
import 'widgets/features_section.dart';
import 'widgets/footer_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/how_it_works_section.dart';
import 'widgets/subjects_section.dart';

/// The landing/home screen. Composed of independent section widgets so each
/// stays small and reusable (see the "Tách UI thành các widget nhỏ" guideline).
///
/// Stateful so it can hold a [ScrollController] and the section keys used to
/// jump to "Tính năng", "Cách hoạt động" and "Môn học".
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // One key per scrollable section target.
  final Map<HomeSection, GlobalKey> _sectionKeys = {
    for (final s in HomeSection.values) s: GlobalKey(),
  };

  /// Smoothly scrolls so [section] sits at the top of the viewport.
  Future<void> _scrollTo(HomeSection section) async {
    final context = _sectionKeys[section]?.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0,
    );
  }

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
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: const Text('Đăng nhập'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: _HomeDrawer(onSectionTap: _onDrawerSectionTap),
      // SingleChildScrollView so the page scrolls and the keyboard never causes
      // overflow; the heavy grids inside use shrinkWrap with a fixed item count.
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            FeaturesSection(key: _sectionKeys[HomeSection.features]),
            HowItWorksSection(key: _sectionKeys[HomeSection.howItWorks]),
            SubjectsSection(key: _sectionKeys[HomeSection.subjects]),
            FooterSection(onSectionTap: _scrollTo),
          ],
        ),
      ),
    );
  }

  void _onDrawerSectionTap(HomeSection section) {
    Navigator.of(context).pop(); // close the drawer first
    // Wait a frame so the drawer is dismissed before scrolling.
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(section));
  }
}

/// Navigation drawer with the section anchors and auth actions.
class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer({required this.onSectionTap});

  final ValueChanged<HomeSection> onSectionTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  const Text('UNI', style: AppTextStyles.sectionTitle),
                  GradientText(
                    'EDU',
                    style: AppTextStyles.sectionTitle,
                    gradient: AppColors.brandGradient,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final section in HomeSection.values)
              ListTile(
                leading: Icon(section.icon, color: AppColors.primary),
                title: Text(section.label, style: AppTextStyles.bullet),
                onTap: () => onSectionTap(section),
              ),
            const ListTile(
              leading: Icon(Icons.search_outlined, color: AppColors.primary),
              title: Text('Tìm gia sư', style: AppTextStyles.bullet),
            ),
            const Spacer(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Đăng nhập'),
                    ),
                  ),
                  const SizedBox(width: AppDimens.gapSm),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.primaryForeground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Đăng ký'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
