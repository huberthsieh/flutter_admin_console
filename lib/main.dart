import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/theme/app_colors.dart';
import 'app/core/values/app_constants.dart';
import 'app/data/providers/api_client.dart';
import 'app/data/services/auth_service.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 常駐服務：dio client 與登入狀態，整個 App 共用。
  Get.put(ApiClient(), permanent: true);
  await Get.putAsync(() => AuthService().init(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Get.find<AuthService>().isLoggedIn;

    return GetMaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.dashboard : Routes.login,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'NotoSansTC',
        scaffoldBackgroundColor: AppColors.pageBg,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
