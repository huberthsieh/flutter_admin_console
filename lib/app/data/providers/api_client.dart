import 'package:dio/dio.dart';

import '../../core/values/app_constants.dart';
import 'mock_interceptor.dart';

/// 全域共用的 dio 實例封裝。
///
/// 以 [GetxService] 註冊（見 main.dart），整個 App 共用同一個 [Dio]。
/// 當 [AppConstants.useMock] 為 true 時掛上 [MockInterceptor]，
/// 所有請求都會在本地被攔截並回傳假資料。
class ApiClient {
  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        contentType: 'application/json',
      ),
    );

    if (AppConstants.useMock) {
      dio.interceptors.add(MockInterceptor());
    }

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  late final Dio dio;

  /// 登入後帶上 token；登出時傳 null 清除。
  void setAuthToken(String? token) {
    if (token == null) {
      dio.options.headers.remove('Authorization');
      return;
    }
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
}
