import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../providers/api_client.dart';

/// 登入狀態與使用者資訊的單一來源。
///
/// 以 [GetxService] 形式常駐（永不被 GetX 回收），透過 [ApiClient] 打 API，
/// 並把使用者資訊存進 [SharedPreferences] 維持登入狀態。
class AuthService extends GetxService {
  static const String _keyUser = 'auth_user';

  final ApiClient _api = Get.find<ApiClient>();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  bool get isLoggedIn => currentUser.value != null;

  Future<AuthService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyUser);
    if (raw != null) {
      final user = UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      currentUser.value = user;
      _api.setAuthToken(user.token);
    }
    return this;
  }

  /// 登入成功回傳 true；失敗讓 [DioException] 往上拋給 controller 處理。
  Future<bool> login(String username, String password) async {
    final res = await _api.dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );

    final user = UserModel.fromJson(res.data as Map<String, dynamic>);
    currentUser.value = user;
    _api.setAuthToken(user.token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    return true;
  }

  Future<void> logout() async {
    currentUser.value = null;
    _api.setAuthToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}
