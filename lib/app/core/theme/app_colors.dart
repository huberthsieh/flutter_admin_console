import 'package:flutter/material.dart';

/// 全站配色，對齊線上 tnparking 樣式。
abstract class AppColors {
  AppColors._();

  // 主色（按鈕 / 連結 / 啟用狀態 / 分頁選取）
  static const Color primary = Color(0xFF155AD3);

  // 左側選單
  static const Color sidebarBg = Color(0xFF1F2032);
  static const Color sidebarBadge = Color(0xFF363749);
  static const Color sidebarText = Color(0xFFD6D6E0);
  static const Color sidebarChevron = Color(0xFF8A8AA0);

  // 內容區
  static const Color pageBg = Color(0xFFF4F5F9);
  static const Color cardBg = Colors.white;
  static const Color tableHeaderBg = Color(0xFFEDEFF7);
  static const Color border = Color(0xFFE6E8EE);
  static const Color divider = Color(0xFFEEF0F4);

  // 文字
  static const Color textPrimary = Color(0xFF2B2B40);
  static const Color textTitle = Color(0xFF1976E5);
  static const Color textMuted = Color(0xFF9AA0AE);
  static const Color textBody = Color(0xFF4B5563);

  // 狀態
  static const Color statusActive = primary; // 啟用
  static const Color statusPending = Color(0xFF2B2B40); // 待驗證（粗體深色）
}
