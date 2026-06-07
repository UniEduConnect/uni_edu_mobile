import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

/// Root widget: configures [MaterialApp] with the shared theme and the
/// initial screen.
class UniEduApp extends StatelessWidget {
  const UniEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNI-EDU',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}
