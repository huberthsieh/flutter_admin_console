import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuItem {
  final String id;
  final String label;
  final IconData icon;
  final String route;

  const MenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
  });
}

class Sidebar extends StatelessWidget {
  final String selectedMenu;
  final VoidCallback? onMenuItemTap;

  const Sidebar({
    super.key,
    required this.selectedMenu,
    this.onMenuItemTap,
  });

  static const List<MenuItem> menuItems = [
    MenuItem(
      id: 'home',
      label: '首頁',
      icon: Icons.home_outlined,
      route: '/home',
    ),
    MenuItem(
      id: 'users',
      label: '用戶管理',
      icon: Icons.people_outline,
      route: '/users',
    ),
    MenuItem(
      id: 'products',
      label: '產品管理',
      icon: Icons.inventory_2_outlined,
      route: '/products',
    ),
    MenuItem(
      id: 'orders',
      label: '訂單管理',
      icon: Icons.shopping_cart_outlined,
      route: '/orders',
    ),
    MenuItem(
      id: 'analytics',
      label: '數據分析',
      icon: Icons.analytics_outlined,
      route: '/analytics',
    ),
    MenuItem(
      id: 'settings',
      label: '系統設定',
      icon: Icons.settings_outlined,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sidebar Header
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ...menuItems.map((item) => _buildMenuItem(context, item)),
                const Divider(
                  color: Colors.white24,
                  height: 32,
                  indent: 16,
                  endIndent: 16,
                ),
                _buildMenuItem(
                  context,
                  const MenuItem(
                    id: 'help',
                    label: '幫助中心',
                    icon: Icons.help_outline,
                    route: '/help',
                  ),
                ),
              ],
            ),
          ),
          // Sidebar Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '系統運行正常',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    final isSelected = selectedMenu == item.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go(item.route);
            onMenuItemTap?.call();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Colors.blue.withValues(alpha: 0.5))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? Colors.blue.shade300 : Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
