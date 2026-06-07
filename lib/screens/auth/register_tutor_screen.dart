import 'package:flutter/material.dart';

import '../../core/auth/auth_scope.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth/auth_requests.dart';
import 'login_screen.dart';
import 'widgets/auth_field.dart';
import 'widgets/auth_layout.dart';
import 'widgets/auth_submit_button.dart';

/// Tutor registration. Posts to `POST /api/register/tutor` with the base fields
/// plus the tutor-specific `gender`, `degree` and optional `studentIdNumber`
/// the backend `TutorRegister` DTO accepts.
class RegisterTutorScreen extends StatefulWidget {
  const RegisterTutorScreen({super.key});

  @override
  State<RegisterTutorScreen> createState() => _RegisterTutorScreenState();
}

class _RegisterTutorScreenState extends State<RegisterTutorScreen> {
  static const _genders = ['Nam', 'Nữ', 'Khác'];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _degreeController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String _gender = _genders.first;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _degreeController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);

    final auth = AuthScope.of(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await auth.registerTutor(
        TutorRegister(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          phoneNumber: _phoneController.text.trim(),
          fullname: _nameController.text.trim(),
          gender: _gender,
          degree: _degreeController.text.trim(),
          studentIdNumber: _studentIdController.text.trim(),
        ),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Đăng ký gia sư thành công! Vui lòng đăng nhập.')),
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
      title: 'Trở thành gia sư',
      subtitle: 'Tham gia đội ngũ gia sư chất lượng của UNI-EDU',
      headerIcon: Icons.cast_for_education_outlined,
      footer: _LoginLink(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              validator: (v) {
                final t = v?.trim() ?? '';
                if (t.isEmpty) return 'Vui lòng nhập số điện thoại';
                if (t.length < 9) return 'Số điện thoại không hợp lệ';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _GenderField(
              gender: _gender,
              genders: _genders,
              onChanged: (g) => setState(() => _gender = g),
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Bằng cấp / Chứng chỉ',
              controller: _degreeController,
              hint: 'VD: Cử nhân Sư phạm Toán - ĐH Sư phạm HN',
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.workspace_premium_outlined,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập bằng cấp' : null,
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Mã số sinh viên (nếu có)',
              controller: _studentIdController,
              hint: 'VD: SE150123',
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.numbers_outlined,
            ),
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
              label: 'Gửi đăng ký gia sư',
              loading: _loading,
              loadingLabel: 'Đang gửi...',
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
}

/// Gender dropdown for the tutor form.
class _GenderField extends StatelessWidget {
  const _GenderField({
    required this.gender,
    required this.genders,
    required this.onChanged,
  });

  final String gender;
  final List<String> genders;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giới tính', style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
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
            child: DropdownButton<String>(
              value: gender,
              isExpanded: true,
              style: AppTextStyles.bullet,
              items: [
                for (final g in genders)
                  DropdownMenuItem(value: g, child: Text(g)),
              ],
              onChanged: (g) => onChanged(g ?? gender),
            ),
          ),
        ),
      ],
    );
  }
}

/// "Already have an account?" link back to login.
class _LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}
