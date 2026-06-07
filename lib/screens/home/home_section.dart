import 'package:flutter/material.dart';

/// The home page sections that the nav (drawer + footer) can jump to.
enum HomeSection {
  features('Tính năng', Icons.auto_awesome_outlined),
  howItWorks('Cách hoạt động', Icons.timeline_outlined),
  subjects('Môn học', Icons.menu_book_outlined);

  const HomeSection(this.label, this.icon);

  final String label;
  final IconData icon;
}
