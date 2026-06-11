import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade400, Colors.blue.shade700],
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(32),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.admin_panel_settings,
                        size: 64, color: Colors.blue),
                    const SizedBox(height: 16),
                    const Text(
                      '停車營運管理系統',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: controller.usernameController,
                      decoration: const InputDecoration(
                        labelText: '帳號',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '請輸入帳號' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '密碼',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? '請輸入密碼' : null,
                      onFieldSubmitted: (_) => controller.submit(),
                    ),
                    Obx(() {
                      final msg = controller.errorMessage.value;
                      if (msg == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          msg,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Obx(
                      () => ElevatedButton(
                        onPressed:
                            controller.isLoading.value ? null : controller.submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('登入', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '提示：Mock 模式下輸入任意帳號密碼即可登入',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
