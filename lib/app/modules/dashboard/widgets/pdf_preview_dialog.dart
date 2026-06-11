import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../core/theme/app_colors.dart';

/// PDF 預覽對話框，支援以 bytes（檔案匯入）或內建範例 asset 開啟。
class PdfPreviewDialog extends StatelessWidget {
  final Uint8List? data;
  final String? assetPath;
  final String title;

  const PdfPreviewDialog({
    super.key,
    this.data,
    this.assetPath,
    required this.title,
  });

  static Future<void> show({
    Uint8List? data,
    String? assetPath,
    String title = 'PDF 預覽',
  }) {
    return Get.dialog(
      PdfPreviewDialog(data: data, assetPath: assetPath, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewer = data != null
        ? PdfViewer.data(data!, sourceName: title)
        : PdfViewer.asset(assetPath!);

    return Dialog(
      child: SizedBox(
        width: 720,
        height: 640,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close, color: Colors.white),
                    splashRadius: 18,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFE9EBF0),
                child: viewer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
