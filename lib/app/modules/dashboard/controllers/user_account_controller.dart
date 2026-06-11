import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/user_account.dart';
import '../../../data/providers/api_client.dart';

class UserAccountController extends GetxController {
  final ApiClient _api = Get.find<ApiClient>();

  static const int pageSize = 10;

  final isLoading = false.obs;
  final RxList<UserAccount> _all = <UserAccount>[].obs;
  final keyword = ''.obs;
  final page = 1.obs;

  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    isLoading.value = true;
    try {
      final res = await _api.dio.get('/accounts');
      final items = (res.data['items'] as List)
          .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
          .toList();
      _all.assignAll(items);
    } finally {
      isLoading.value = false;
    }
  }

  List<UserAccount> get _filtered {
    final k = keyword.value.trim();
    if (k.isEmpty) return _all;
    return _all
        .where((u) => u.account.contains(k) || u.name.contains(k))
        .toList();
  }

  int get totalPages => (_filtered.length / pageSize).ceil().clamp(1, 9999);

  List<UserAccount> get pageItems {
    final start = (page.value - 1) * pageSize;
    final end = (start + pageSize).clamp(0, _filtered.length);
    if (start >= _filtered.length) return const [];
    return _filtered.sublist(start, end);
  }

  void search() {
    keyword.value = searchController.text;
    page.value = 1;
  }

  void goToPage(int p) {
    if (p < 1 || p > totalPages) return;
    page.value = p;
  }

  /// 檔案匯入：使用 file_picker 選擇 Excel / CSV。
  Future<PlatformFile?> pickImportFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
      withData: true,
    );
    return result?.files.single;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
