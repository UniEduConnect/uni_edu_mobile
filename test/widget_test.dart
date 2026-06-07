// Widget test for the home screen — verifies the key landing sections render.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uni_edu_mobile/screens/home/home_screen.dart';

void main() {
  testWidgets('Home screen renders the main section headings', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Section subtitles are unique strings, so they make reliable anchors.
    expect(
      find.text('Hệ thống quản lý học tập toàn diện với công nghệ AI tiên tiến'),
      findsOneWidget,
    );
    expect(
      find.text('Quy trình đơn giản, minh bạch cho cả gia sư và học sinh'),
      findsOneWidget,
    );
    expect(
      find.text('Đầy đủ các môn học theo chương trình phổ thông, từ lớp 1 đến lớp 12'),
      findsOneWidget,
    );
  });

  testWidgets('How it works toggle switches to the student flow', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Tutor flow is shown first.
    expect(find.text('Nhận lương'), findsOneWidget);

    // The toggle sits below the fold, so scroll it into view before tapping.
    final studentTab = find.text('Dành cho Học sinh');
    await tester.ensureVisible(studentTab);
    await tester.pumpAndSettle();
    await tester.tap(studentTab);
    await tester.pumpAndSettle();

    // Student flow is now shown instead.
    expect(find.text('Báo cáo cho phụ huynh'), findsOneWidget);
    expect(find.text('Nhận lương'), findsNothing);
  });

  testWidgets('Drawer exposes the section nav links', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Open the navigation drawer via the app bar hamburger.
    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Tính năng'), findsWidgets);
    expect(find.text('Cách hoạt động'), findsWidgets);
    expect(find.text('Môn học'), findsWidgets);
    expect(find.text('Tìm gia sư'), findsWidgets);
  });

  testWidgets('Footer renders brand and copyright', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('© 2025 UNI-EDU. All rights reserved.'), findsOneWidget);
    expect(find.text('Khám phá'), findsOneWidget);
  });
}
