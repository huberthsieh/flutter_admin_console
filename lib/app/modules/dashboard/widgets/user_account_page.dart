import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_account.dart';
import '../controllers/user_account_controller.dart';
import 'pdf_preview_dialog.dart';

class UserAccountPage extends GetView<UserAccountController> {
  const UserAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '使用者帳號',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textTitle,
            ),
          ),
          const SizedBox(height: 24),
          _toolbar(),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : _table(),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => _pagination()),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Row(
      children: [
        SizedBox(
          width: 320,
          height: 48,
          child: TextField(
            controller: controller.searchController,
            onSubmitted: (_) => controller.search(),
            decoration: const InputDecoration(
              hintText: '請輸入帳號或名稱進行搜尋',
              hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _squareButton(
          onTap: controller.search,
          child: SvgPicture.asset(
            'assets/svg/search2.svg',
            width: 20,
            colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        const Spacer(),
        _outlinedAction(
          icon: 'assets/svg/print.svg',
          label: '報表預覽',
          onTap: () => PdfPreviewDialog.show(
            assetPath: 'assets/sample/sample_report.pdf',
            title: '使用者帳號報表',
          ),
        ),
        const SizedBox(width: 12),
        _outlinedAction(
          icon: 'assets/svg/file_import.svg',
          label: '匯入',
          onTap: _handleImport,
        ),
        const SizedBox(width: 12),
        _primaryAction(
          icon: 'assets/svg/add.svg',
          label: '新增使用者',
          onTap: () => Get.snackbar('新增使用者', '開啟新增表單（示範）',
              snackPosition: SnackPosition.BOTTOM),
        ),
      ],
    );
  }

  Widget _squareButton({required VoidCallback onTap, required Widget child}) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 48, height: 48, child: Center(child: child)),
      ),
    );
  }

  Widget _primaryAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              SvgPicture.asset(icon,
                  width: 14,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              const SizedBox(width: 10),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlinedAction({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: [
              SvgPicture.asset(icon,
                  width: 16,
                  colorFilter: const ColorFilter.mode(
                      AppColors.primary, BlendMode.srcIn)),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _table() {
    const headers = ['帳號', '名稱', '郵件地址', '員工編號', '狀態', '帳號建立時間', '最後更新時間'];
    // 各欄寬度比例 + 末欄操作。
    const flexes = [3, 3, 4, 3, 3, 4, 4];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 表頭
          Container(
            color: AppColors.tableHeaderBg,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                for (var i = 0; i < headers.length; i++)
                  Expanded(
                    flex: flexes[i],
                    child: Text(headers[i],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          // 內容
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.pageItems.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, i) =>
                    _row(controller.pageItems[i], flexes),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(UserAccount u, List<int> flexes) {
    Widget cell(int flex, Widget child) =>
        Expanded(flex: flex, child: child);
    Widget text(String? v) => Text(
          (v == null || v.isEmpty) ? '-' : v,
          style: const TextStyle(fontSize: 16, color: AppColors.textBody),
          overflow: TextOverflow.ellipsis,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          cell(flexes[0], text(u.account)),
          cell(flexes[1], text(u.name)),
          cell(flexes[2], text(u.email)),
          cell(flexes[3], text(u.employeeId)),
          cell(
            flexes[4],
            Text(
              u.enabled ? '啟用' : '待驗證',
              style: TextStyle(
                fontSize: 16,
                fontWeight: u.enabled ? FontWeight.w600 : FontWeight.w700,
                color: u.enabled
                    ? AppColors.statusActive
                    : AppColors.statusPending,
              ),
            ),
          ),
          cell(flexes[5], text(u.createdAt)),
          cell(flexes[6], text(u.updatedAt)),
          SizedBox(
            width: 48,
            child: IconButton(
              onPressed: () => Get.snackbar('編輯', '編輯帳號 ${u.account}（示範）',
                  snackPosition: SnackPosition.BOTTOM),
              icon: SvgPicture.asset('assets/svg/edit.svg', width: 20),
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pagination() {
    final total = controller.totalPages;
    final current = controller.page.value;

    // 顯示：1 2 3 4 … last，超過範圍以 … 省略。
    final pages = <int>{1, 2, 3, 4, total, current, current - 1, current + 1}
        .where((p) => p >= 1 && p <= total)
        .toList()
      ..sort();

    final widgets = <Widget>[];
    int? prev;
    for (final p in pages) {
      if (prev != null && p - prev > 1) widgets.add(_ellipsis());
      widgets.add(_pageButton('$p', selected: p == current,
          onTap: () => controller.goToPage(p)));
      prev = p;
    }
    widgets.add(_pageButton('>',
        onTap: () => controller.goToPage(current + 1)));

    return Center(
      child: Wrap(spacing: 8, children: widgets),
    );
  }

  Widget _ellipsis() => _pageButton('...', onTap: () {});

  Widget _pageButton(String label,
      {bool selected = false, required VoidCallback onTap}) {
    return Material(
      color: selected ? AppColors.primary : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: selected ? null : Border.all(color: AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textBody,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleImport() async {
    final file = await controller.pickImportFile();
    if (file == null) return;
    Get.snackbar(
      '匯入檔案',
      '已選擇：${file.name}（${file.size} bytes）',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
