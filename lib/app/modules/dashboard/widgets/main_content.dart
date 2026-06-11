import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import 'user_account_page.dart';

class MainContent extends GetView<DashboardController> {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.pageBg,
      child: Obx(() {
        // 「基本資料作業」對應線上的「使用者帳號」清單。
        if (controller.selectedMenu.value == 'basic') {
          return const UserAccountPage();
        }
        return _placeholder();
      }),
    );
  }

  Widget _placeholder() {
    final label = DashboardController.navItems
        .firstWhere((e) => e.id == controller.selectedMenu.value)
        .label;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.construction, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text('「$label」功能建置中',
              style: const TextStyle(
                  fontSize: 18, color: AppColors.textBody)),
        ],
      ),
    );
  }
}
