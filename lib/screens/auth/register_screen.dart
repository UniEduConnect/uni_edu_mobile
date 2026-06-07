import 'package:flutter/material.dart';

import '../../core/auth/auth_scope.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth/auth_requests.dart';
import '../../models/auth/auth_role.dart';
import 'login_screen.dart';
import 'register_tutor_screen.dart';
import 'widgets/auth_field.dart';
import 'widgets/auth_layout.dart';
import 'widgets/auth_submit_button.dart';

/// Student / parent registration. The backend registers by role-specific
/// endpoint, so the form offers a role toggle: [AuthRole.student] adds the
/// required School + Grade fields, [AuthRole.parent] needs only the base fields.
/// Gia sư đăng ký ở màn hình riêng ([RegisterTutorScreen]).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _schoolController = TextEditingController();

  AuthRole _role = AuthRole.student;
  int _grade = 1;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final auth = AuthScope.of(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();

    try {
      if (_role == AuthRole.student) {
        await auth.registerStudent(
          StudentRegister(
            email: email,
            password: password,
            phoneNumber: phone,
            fullname: name,
            school: _schoolController.text.trim(),
            grade: _grade,
          ),
        );
      } else {
        await auth.registerParent(
          ParentRegister(
            email: email,
            password: password,
            phoneNumber: phone,
            fullname: name,
          ),
        );
      }
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập.')),
      );
      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.displayMessage)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Đăng ký tài khoản',
      subtitle: 'Tham gia UNI-EDU ngay hôm nay',
      headerIcon: Icons.person_add_alt_1,
      footer: _Footer(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RoleToggle(
              role: _role,
              onChanged: (r) => setState(() => _role = r),
            ),
            const SizedBox(height: AppDimens.gapLg),
            AuthField(
              label: 'Họ và tên',
              controller: _nameController,
              hint: 'Nguyễn Văn A',
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.badge_outlined,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Email',
              controller: _emailController,
              hint: 'email@example.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.mail_outline,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Số điện thoại',
              controller: _phoneController,
              hint: '0901234567',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.phone_outlined,
              validator: _validatePhone,
            ),
            if (_role == AuthRole.student) ...[
              const SizedBox(height: 16),
              AuthField(
                label: 'Trường',
                controller: _schoolController,
                hint: 'VD: THPT Chuyên Hà Nội - Amsterdam',
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.school_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Vui lòng nhập tên trường'
                    : null,
              ),
              const SizedBox(height: 16),
              _GradeField(
                grade: _grade,
                onChanged: (g) => setState(() => _grade = g),
              ),
            ],
            const SizedBox(height: 16),
            AuthField(
              label: 'Mật khẩu',
              controller: _passwordController,
              hint: 'Tối thiểu 6 ký tự',
              obscureText: true,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.lock_outline,
              validator: (v) => (v == null || v.length < 6)
                  ? 'Mật khẩu phải có ít nhất 6 ký tự'
                  : null,
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Xác nhận mật khẩu',
              controller: _confirmController,
              hint: 'Nhập lại mật khẩu',
              obscureText: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.lock_outline,
              validator: (v) => (v != _passwordController.text)
                  ? 'Mật khẩu xác nhận không khớp'
                  : null,
            ),
            const SizedBox(height: 24),
            AuthSubmitButton(
              label: 'Đăng ký',
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  static String? _validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập email';
    if (!v.contains('@') || !v.contains('.')) return 'Email không hợp lệ';
    return null;
  }

  static String? _validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (v.length < 9) return 'Số điện thoại không hợp lệ';
    return null;
  }
}

/// Segmented toggle between the Student and Parent register flows.
class _RoleToggle extends StatelessWidget {
  const _RoleToggle({required this.role, required this.onChanged});

  final AuthRole role;
  final ValueChanged<AuthRole> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      ),
      child: Row(
        children: [
          _option(AuthRole.student, Icons.school_outlined),
          _option(AuthRole.parent, Icons.family_restroom_outlined),
        ],
      ),
    );
  }

  Widget _option(AuthRole value, IconData icon) {
    final selected = role == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? AppColors.primary : AppColors.mutedForeground,
              ),
              const SizedBox(width: 6),
              Text(
                value.label,
                style: AppTextStyles.badge.copyWith(
                  color: selected ? AppColors.primary : AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grade (lớp 1–12) picker for the student flow.
class _GradeField extends StatelessWidget {
  const _GradeField({required this.grade, required this.onChanged});

  final int grade;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lớp', style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
        const SizedBox(height: 6),
        InputDecorator(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.gapMd,
              vertical: 6,
            ),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: grade,
              isExpanded: true,
              style: AppTextStyles.bullet,
              items: [
                for (var g = 1; g <= 12; g++)
                  DropdownMenuItem(value: g, child: Text('Lớp $g')),
              ],
              onChanged: (g) => onChanged(g ?? grade),
            ),
          ),
        ),
      ],
    );
  }
}

/// Links to login and the tutor-registration flow.
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Đã có tài khoản? ', style: AppTextStyles.cardBody),
            GestureDetector(
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: Text(
                'Đăng nhập',
                style: AppTextStyles.cardBody.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.gapSm),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Bạn là gia sư? ', style: AppTextStyles.cardBody),
            GestureDetector(
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const RegisterTutorScreen()),
              ),
              child: Text(
                'Đăng ký trở thành gia sư',
                style: AppTextStyles.cardBody.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
