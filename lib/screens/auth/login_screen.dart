import 'package:flutter/material.dart';

import '../../core/auth/auth_scope.dart';
import '../../core/network/api_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/auth/auth_requests.dart';
import 'register_screen.dart';
import 'widgets/auth_field.dart';
import 'widgets/auth_layout.dart';
import 'widgets/auth_submit_button.dart';

/// Sign-in screen. Posts to `POST /api/login` via [AuthScope]; on success the
/// access token is stored and the screen pops back to wherever it was opened
/// from (the home screen reflects the new auth state).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
      await auth.login(
        LoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Đăng nhập thành công!')),
      );
      navigator.pop();
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
      title: 'Đăng nhập',
      subtitle: 'Chào mừng trở lại UNI-EDU',
      footer: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Chưa có tài khoản? ', style: AppTextStyles.cardBody),
          GestureDetector(
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
            child: Text(
              'Đăng ký ngay',
              style: AppTextStyles.cardBody.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              label: 'Email',
              controller: _emailController,
              hint: 'student.minh@gmail.com',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.mail_outline,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            AuthField(
              label: 'Mật khẩu',
              controller: _passwordController,
              hint: 'Uni12345',
              obscureText: true,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.lock_outline,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Vui lòng nhập mật khẩu' : null,
            ),
            const SizedBox(height: 24),
            AuthSubmitButton(
              label: 'Đăng nhập',
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
}
