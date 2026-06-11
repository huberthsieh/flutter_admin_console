import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../widgets/header.dart';
import '../widgets/main_content.dart';
import '../widgets/sidebar.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      key: controller.scaffoldKey,
      drawer: isMobile
          ? Drawer(child: Sidebar(onMenuItemTap: controller.closeDrawer))
          : null,
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: Row(
              children: [
                if (!isMobile) const Sidebar(),
                const Expanded(child: MainContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
