import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';

/// 頂部白色列：左側臺南市政府交通局 logo，右側登入帳號。
class Header extends GetView<DashboardController> {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: controller.openDrawer,
            ),
          Image.asset(
            'assets/image/header_logo.png',
            height: 44,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    controller.accountName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  offset: const Offset(0, 48),
                  onSelected: (v) {
                    if (v == 'logout') controller.logout();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(children: [
                        Icon(Icons.logout, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Text('登出', style: TextStyle(color: Colors.red)),
                      ]),
                    ),
                  ],
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
