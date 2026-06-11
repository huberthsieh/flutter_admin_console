import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/services/auth_service.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      middlewares: [_AuthMiddleware()],
    ),
  ];
}

/// 未登入時擋下需要授權的頁面，導回登入頁。
class _AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final loggedIn = Get.find<AuthService>().isLoggedIn;
    return loggedIn ? null : const RouteSettings(name: Routes.login);
  }
}
