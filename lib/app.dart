import 'package:flutter/material.dart';

import 'core/auth/auth_controller.dart';
import 'core/auth/auth_scope.dart';
import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

/// Root widget: owns the app-wide [AuthController], provides it to the tree via
/// [AuthScope], and configures the [MaterialApp] with the shared theme and the
/// initial screen.
///
/// Stateful so the [AuthController]'s lifecycle (creation, startup token load,
/// disposal) is tied to the app.
class UniEduApp extends StatefulWidget {
  const UniEduApp({super.key});

  @override
  State<UniEduApp> createState() => _UniEduAppState();
}

class _UniEduAppState extends State<UniEduApp> {
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth = AuthController();
    // Restore any persisted session so a returning user stays signed in.
    _auth.bootstrap();
  }

  @override
  void dispose() {
    _auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      controller: _auth,
      child: MaterialApp(
        title: 'UNI-EDU',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const HomeScreen(),
      ),
    );
  }
}
