import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/sidebar.dart';
import 'widgets/main_content.dart';

class DashboardScreen extends StatefulWidget {
  final String selectedMenu;

  const DashboardScreen({
    super.key,
    this.selectedMenu = 'home',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? Drawer(
              child: Sidebar(
                selectedMenu: widget.selectedMenu,
                onMenuItemTap: _closeDrawer,
              ),
            )
          : null,
      body: Column(
        children: [
          Header(onMenuPressed: _openDrawer),
          Expanded(
            child: Row(
              children: [
                // 桌面版 Sidebar
                if (!isMobile)
                  Sidebar(selectedMenu: widget.selectedMenu),
                // 主要內容區
                Expanded(
                  child: MainContent(selectedMenu: widget.selectedMenu),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
