import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';

/// 左側深色選單：標題 + 編號圓徽的功能分類。
class Sidebar extends GetView<DashboardController> {
  final VoidCallback? onMenuItemTap;

  const Sidebar({super.key, this.onMenuItemTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: AppColors.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Text(
              '停車營運管理系統',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: DashboardController.navItems.length,
              itemBuilder: (context, i) {
                final item = DashboardController.navItems[i];
                return _buildItem(item, i + 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(NavItem item, int number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          controller.selectMenu(item.id);
          onMenuItemTap?.call();
        },
        child: Obx(() {
          final selected = controller.selectedMenu.value == item.id;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            color: selected ? Colors.white.withValues(alpha: 0.06) : null,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.sidebarBadge,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.sidebarChevron,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.sidebarText,
                      fontSize: 17,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.sidebarChevron,
                  size: 22,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
