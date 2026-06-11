import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

/// 左側選單項目（對齊線上 tnparking 的功能分類）。
class NavItem {
  final String id;
  final String label;
  const NavItem(this.id, this.label);
}

class DashboardController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<NavItem> navItems = [
    NavItem('hr', '人事薪資管理'),
    NavItem('basic', '基本資料作業'),
    NavItem('ticketing', '開單管理'),
    NavItem('pda', 'PDA管理作業'),
    NavItem('fare', '票務作業'),
    NavItem('counter_pay', '櫃台(繳費)作業'),
    NavItem('counter', '櫃台作業'),
    NavItem('business', '業務管理'),
  ];

  /// 目前選取的選單 id。預設 basic → 顯示「使用者帳號」。
  final selectedMenu = 'basic'.obs;

  String get accountName => _auth.currentUser.value?.displayName ?? 'Greenpark';

  void selectMenu(String id) => selectedMenu.value = id;

  void openDrawer() => scaffoldKey.currentState?.openDrawer();
  void closeDrawer() => scaffoldKey.currentState?.closeDrawer();

  Future<void> logout() async {
    await _auth.logout();
    Get.offAllNamed(Routes.login);
  }
}
