import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/feature_item.dart';
import '../models/how_it_works_step.dart';
import '../models/subject.dart';

/// Static seed content for the landing/home page.
///
/// Mirrors the web frontend sections. When a backend is wired up, these lists
/// can be replaced by data loaded from the API (kept here so the UI has a
/// single, obvious source of truth in the meantime).
class HomeContent {
  HomeContent._();

  /// "Tính năng nổi bật" — highlighted features.
  static const List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.verified_user_outlined,
      title: 'Xác thực gia sư',
      description:
          'Kiểm tra lý lịch, bằng cấp và năng lực qua AI + Admin trong 48 giờ',
      accent: AppColors.primary,
    ),
    FeatureItem(
      icon: Icons.psychology_outlined,
      title: 'AI đánh giá',
      description:
          'Tự động tạo đề và chấm điểm, báo cáo tiến độ học tập hàng tháng',
      accent: AppColors.success,
    ),
    FeatureItem(
      icon: Icons.credit_card_outlined,
      title: 'Thanh toán an toàn',
      description: 'Escrow 20%, thanh toán qua MoMo/VNPay, audit log realtime',
      accent: AppColors.primary,
    ),
    FeatureItem(
      icon: Icons.description_outlined,
      title: 'Test online',
      description: 'Thi thử THPT QG 12 môn, AI proctoring chống gian lận',
      accent: AppColors.warning,
    ),
    FeatureItem(
      icon: Icons.videocam_outlined,
      title: 'Học trực tuyến',
      description: 'Tích hợp Zoom/Google Meet, lịch tự động đồng bộ',
      accent: AppColors.primary,
    ),
    FeatureItem(
      icon: Icons.notifications_outlined,
      title: 'Thông báo thông minh',
      description: 'Push notification, email nhắc nhở vắng học tự động',
      accent: AppColors.warning,
    ),
    FeatureItem(
      icon: Icons.language_outlined,
      title: 'Đa ngôn ngữ',
      description: 'Hỗ trợ Tiếng Việt và Tiếng Anh đầy đủ',
      accent: AppColors.info,
    ),
    FeatureItem(
      icon: Icons.smartphone_outlined,
      title: 'Mobile App',
      description: 'Quản lý lớp học mọi lúc mọi nơi trên điện thoại',
      accent: AppColors.success,
    ),
  ];

  /// "Cách hoạt động" — flow for tutors.
  static const List<HowItWorksStep> tutorSteps = [
    HowItWorksStep(
      number: '01',
      title: 'Đăng ký & Xác thực',
      description:
          'Upload bằng điểm, chứng chỉ. AI kiểm tra tự động + Admin phê duyệt trong 48h',
      icon: Icons.how_to_reg_outlined,
    ),
    HowItWorksStep(
      number: '02',
      title: 'Làm bài test',
      description: 'Hoàn thành bài kiểm tra năng lực môn học',
      icon: Icons.fact_check_outlined,
    ),
    HowItWorksStep(
      number: '03',
      title: 'Nhận lớp & Dạy',
      description:
          'Xem lớp phù hợp, đăng ký, thanh toán 10% phí và bắt đầu giảng dạy',
      icon: Icons.menu_book_outlined,
    ),
    HowItWorksStep(
      number: '04',
      title: 'Nhận lương',
      description:
          'Nhận 80% lương hàng tháng, 20% escrow giải ngân sau khi hoàn thành',
      icon: Icons.account_balance_wallet_outlined,
    ),
  ];

  /// "Cách hoạt động" — flow for students.
  static const List<HowItWorksStep> studentSteps = [
    HowItWorksStep(
      number: '01',
      title: 'Đăng ký lớp học',
      description: 'Chọn môn, lịch học, hình thức và mức giá phù hợp',
      icon: Icons.assignment_outlined,
    ),
    HowItWorksStep(
      number: '02',
      title: 'Ghép gia sư',
      description: 'Hệ thống gợi ý gia sư phù hợp, xác nhận và bắt đầu học',
      icon: Icons.groups_outlined,
    ),
    HowItWorksStep(
      number: '03',
      title: 'Học & Đánh giá',
      description: 'Tham gia lớp học, làm test cuối tháng để đo lường tiến độ',
      icon: Icons.bar_chart_outlined,
    ),
    HowItWorksStep(
      number: '04',
      title: 'Báo cáo cho phụ huynh',
      description: 'Phụ huynh nhận báo cáo AI về tiến độ và kết quả học tập',
      icon: Icons.assessment_outlined,
    ),
  ];

  static List<HowItWorksStep> stepsFor(HowItWorksAudience audience) =>
      audience == HowItWorksAudience.tutor ? tutorSteps : studentSteps;

  /// "12 môn học cơ bản" — subjects grid.
  static const List<Subject> subjects = [
    Subject(
      icon: Icons.calculate_outlined,
      name: 'Toán học',
      gradeRange: 'Lớp 1-12',
      gradient: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    Subject(
      icon: Icons.bubble_chart_outlined,
      name: 'Vật lý',
      gradeRange: 'Lớp 6-12',
      gradient: [Color(0xFF22D3EE), Color(0xFF3B82F6)],
    ),
    Subject(
      icon: Icons.science_outlined,
      name: 'Hóa học',
      gradeRange: 'Lớp 8-12',
      gradient: [Color(0xFF4ADE80), Color(0xFF059669)],
    ),
    Subject(
      icon: Icons.eco_outlined,
      name: 'Sinh học',
      gradeRange: 'Lớp 6-12',
      gradient: [Color(0xFF34D399), Color(0xFF0D9488)],
    ),
    Subject(
      icon: Icons.menu_book_outlined,
      name: 'Ngữ văn',
      gradeRange: 'Lớp 1-12',
      gradient: [Color(0xFFFB7185), Color(0xFFDB2777)],
    ),
    Subject(
      icon: Icons.account_balance_outlined,
      name: 'Lịch sử',
      gradeRange: 'Lớp 4-12',
      gradient: [Color(0xFFFBBF24), Color(0xFFEA580C)],
    ),
    Subject(
      icon: Icons.public_outlined,
      name: 'Địa lý',
      gradeRange: 'Lớp 4-12',
      gradient: [Color(0xFF2DD4BF), Color(0xFF0891B2)],
    ),
    Subject(
      icon: Icons.translate_outlined,
      name: 'Tiếng Anh',
      gradeRange: 'Lớp 1-12',
      gradient: [Color(0xFFA78BFA), Color(0xFF9333EA)],
    ),
    Subject(
      icon: Icons.computer_outlined,
      name: 'Tin học',
      gradeRange: 'Lớp 3-12',
      gradient: [Color(0xFF38BDF8), Color(0xFF2563EB)],
    ),
    Subject(
      icon: Icons.balance_outlined,
      name: 'GDCD',
      gradeRange: 'Lớp 6-12',
      gradient: [Color(0xFFFB923C), Color(0xFFEF4444)],
    ),
    Subject(
      icon: Icons.music_note_outlined,
      name: 'Âm nhạc',
      gradeRange: 'Lớp 1-12',
      gradient: [Color(0xFFF472B6), Color(0xFFE11D48)],
    ),
    Subject(
      icon: Icons.palette_outlined,
      name: 'Mỹ thuật',
      gradeRange: 'Lớp 1-12',
      gradient: [Color(0xFFE879F9), Color(0xFF9333EA)],
    ),
  ];
}
