import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../controllers/user_account_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<UserAccountController>(() => UserAccountController());
  }
}
