import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;
    try {
      await _auth.login(usernameController.text, passwordController.text);
      Get.offAllNamed(Routes.dashboard);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data['message'] as String?)
          : null;
      errorMessage.value = msg ?? '登入失敗，請檢查帳號密碼';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
