import 'package:dio/dio.dart';

/// 攔截所有請求並回傳本地假資料，不會真的連到後端。
///
/// 要改成串接正式 API，把 [AppConstants.useMock] 設為 false 即可，
/// 不需要動到任何 service / controller。
class MockInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 模擬網路延遲
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final body = _route(options);
    if (body == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode: 404,
            data: {'message': 'mock route not found: ${options.path}'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    handler.resolve(
      Response(requestOptions: options, statusCode: 200, data: body),
    );
  }

  Map<String, dynamic>? _route(RequestOptions options) {
    final path = options.path;

    if (path.endsWith('/auth/login')) {
      final data = options.data as Map?;
      final username = data?['username'] as String? ?? 'admin';
      return {
        'id': 1,
        'username': username,
        'displayName': username,
        'role': 'admin',
        'token': 'mock-token-abc123',
      };
    }

    if (path.endsWith('/dashboard/stats')) {
      return {
        'totalUsers': 1234,
        'todayOrders': 56,
        'revenue': 12345,
        'pending': 8,
      };
    }

    if (path.endsWith('/accounts')) {
      // 名單後補足填充列，讓分頁真實到 14 頁（pageSize 10）。
      final filler = List.generate(
        130,
        (i) => {
          'account': '1${(i + 100).toString().padLeft(3, '0')}',
          'name': '員工 ${i + 11}',
          'email': null,
          'employeeId': '${i + 100}'.padLeft(3, '0'),
          'status': i.isEven ? '啟用' : '待驗證',
          'createdAt': null,
          'updatedAt': '115/0${(i % 9) + 1}/01 09:00',
        },
      );
      return {'items': [..._accounts, ...filler]};
    }

    return null;
  }

  // 對齊線上「使用者帳號」清單的示範資料。
  static final List<Map<String, dynamic>> _accounts = [
    {'account': '@shu', 'name': '胥慧勳', 'email': null, 'employeeId': '063', 'status': '啟用', 'createdAt': null, 'updatedAt': null},
    {'account': '001', 'name': '張智雅', 'email': null, 'employeeId': '001', 'status': '待驗證', 'createdAt': null, 'updatedAt': '114/12/15 15:32'},
    {'account': '006', 'name': '林雅娟', 'email': null, 'employeeId': '006', 'status': '啟用', 'createdAt': null, 'updatedAt': null},
    {'account': '015', 'name': '林美香', 'email': 'tu9900@mail.tainan.gov.tw', 'employeeId': '015', 'status': '待驗證', 'createdAt': '115/03/23 09:40', 'updatedAt': '115/03/25 17:35'},
    {'account': '0150', 'name': '林美香', 'email': null, 'employeeId': '015', 'status': '啟用', 'createdAt': '115/03/30 09:58', 'updatedAt': '115/05/11 15:23'},
    {'account': '017AB', 'name': '鄭秀慧', 'email': null, 'employeeId': '017', 'status': '啟用', 'createdAt': null, 'updatedAt': '115/05/18 12:08'},
    {'account': '033', 'name': '蔡全益', 'email': null, 'employeeId': '033', 'status': '啟用', 'createdAt': null, 'updatedAt': '115/04/08 12:09'},
    {'account': '041', 'name': '王建宏', 'email': null, 'employeeId': '041', 'status': '啟用', 'createdAt': '115/01/10 08:20', 'updatedAt': '115/05/01 11:00'},
    {'account': '052', 'name': '陳怡君', 'email': 'chen@mail.tainan.gov.tw', 'employeeId': '052', 'status': '待驗證', 'createdAt': '115/02/18 14:05', 'updatedAt': '115/05/20 09:12'},
    {'account': '066', 'name': '黃志明', 'email': null, 'employeeId': '066', 'status': '啟用', 'createdAt': null, 'updatedAt': '115/04/22 16:48'},
  ];
}
