import 'package:flutter/material.dart';

import '../../core/auth/auth_scope.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth/auth_user.dart';
import '../../widgets/gradient_text.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
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

  /// Opens the login screen.
  void _openLogin() => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );

  /// Opens the register screen.
  void _openRegister() => Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const RegisterScreen()),
  );

  @override
  Widget build(BuildContext context) {
    // maybeOf so the screen still works when pumped without an AuthScope
    // (e.g. widget tests). Listens so the app bar reflects login/logout.
    final user = AuthScope.maybeOf(context)?.user;
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
          if (user == null)
            TextButton(
              onPressed: _openLogin,
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('Đăng nhập'),
            )
          else
            IconButton(
              tooltip: 'Đăng xuất',
              onPressed: () => AuthScope.of(context, listen: false).logout(),
              icon: const Icon(Icons.logout, color: AppColors.primary),
            ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: _HomeDrawer(
        user: user,
        onSectionTap: _onDrawerSectionTap,
        onLogin: () {
          Navigator.of(context).pop();
          _openLogin();
        },
        onRegister: () {
          Navigator.of(context).pop();
          _openRegister();
        },
        onLogout: () {
          Navigator.of(context).pop();
          AuthScope.of(context, listen: false).logout();
        },
      ),
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
  const _HomeDrawer({
    required this.user,
    required this.onSectionTap,
    required this.onLogin,
    required this.onRegister,
    required this.onLogout,
  });

  final AuthUser? user;
  final ValueChanged<HomeSection> onSectionTap;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onLogout;

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
              child: user == null ? _authButtons() : _accountRow(),
            ),
          ],
        ),
      ),
    );
  }

  /// Login / register buttons shown to signed-out visitors.
  Widget _authButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.30)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
              ),
            ),
            onPressed: onLogin,
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
            onPressed: onRegister,
            child: const Text('Đăng ký'),
          ),
        ),
      ],
    );
  }

  /// Signed-in account summary: full name, a role badge, and email + logout.
  Widget _accountRow() {
    final email = user!.email;
    final roleLabel = user!.role?.label;
    // Show the name when the token carries it; otherwise fall back to the role
    // so the row never looks empty (e.g. tokens issued before the name claim).
    final title = user!.name.isNotEmpty ? user!.name : (roleLabel ?? 'Tài khoản');
    final showRoleBadge = roleLabel != null && user!.name.isNotEmpty;
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: AppColors.secondary,
          child: Icon(Icons.person_outline, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimens.gapSm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showRoleBadge) ...[
                    const SizedBox(width: AppDimens.gapSm),
                    _RoleBadge(label: roleLabel),
                  ],
                ],
              ),
              if (email.isNotEmpty)
                Text(
                  email,
                  style: AppTextStyles.cardBody,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Đăng xuất',
          onPressed: onLogout,
          icon: const Icon(Icons.logout, color: AppColors.primary),
        ),
      ],
    );
  }
}

/// Small pill showing the signed-in user's role (e.g. "Phụ huynh").
class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(
          fontSize: 11,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
