/// 全域常數設定。
///
/// `useMock` 為 true 時，[ApiClient] 會攔截所有請求並回傳本地假資料，
/// 不會真的打到 [apiBaseUrl]。要串接正式後端時改成 false。
class AppConstants {
  AppConstants._();

  static const bool useMock = true;

  /// 線上正式 API（對齊 tnparking.tainan.gov.tw）。
  static const String apiBaseUrl = 'https://api-tnparking.tainan.gov.tw/api/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String appTitle = '停車營運管理系統';
}
