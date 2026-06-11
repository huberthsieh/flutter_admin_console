# Flutter Admin Console（停車營運管理系統）

使用 Flutter Web 開發的後台管理系統，技術選型對齊線上正式站
[tnparking.tainan.gov.tw](https://tnparking.tainan.gov.tw)：**Flutter + CanvasKit + GetX + dio**。

> 目前 API 預設為 **Mock 模式**（本地假資料，不連後端），方便直接運行與開發。
> 切換到正式 API 的方式見下方〈Mock / 正式 API 切換〉。

---

## 技術棧

| 分類 | 技術 | 說明 |
|------|------|------|
| 框架 | Flutter Web (dart2js) | 與線上站相同 |
| 算繪引擎 | CanvasKit | 在 `web/index.html` 指定 `renderer: "canvaskit"` |
| 狀態管理 / 路由 / DI | **GetX** (`get`) | `GetMaterialApp`、`GetxController`、`Obx`、`Bindings` |
| HTTP client | **dio** | 共用單一實例，可掛攔截器 |
| SVG 圖示 | flutter_svg | 直接使用線上站的真實 SVG 素材 |
| 檔案上傳 / 匯入 | file_picker | Excel / CSV 匯入 |
| PDF 預覽 | pdfrx | 報表預覽（WASM，支援 Web）|
| 多語系 / 日期 | intl | |
| 本地儲存 | shared_preferences | 維持登入狀態 / token |
| 字型 | NotoSansTC / Roboto | 與線上站相同，已內嵌 |

---

## 專案結構

採用 GetX 標準模組架構（每個功能模組各自有 controller / binding / view）：

```
assets/
├── fonts/                           # NotoSansTC / Roboto（取自線上站）
├── image/header_logo.png            # 臺南市政府交通局 logo
├── svg/                             # 線上站真實 SVG 素材（edit/search/add...）
└── sample/sample_report.pdf         # PDF 預覽示範檔

lib/
├── main.dart                        # 進入點：註冊服務、GetMaterialApp、主題
└── app/
    ├── core/
    │   ├── theme/app_colors.dart    # 全站配色（對齊線上樣式）
    │   └── values/app_constants.dart# API base URL、useMock 開關、逾時設定
    ├── data/
    │   ├── models/                  # user_model / user_account
    │   ├── providers/
    │   │   ├── api_client.dart      # dio 封裝（共用實例 + token）
    │   │   └── mock_interceptor.dart# Mock 模式攔截器（本地假資料）
    │   └── services/
    │       └── auth_service.dart    # GetxService：登入狀態單一來源
    ├── routes/
    │   ├── app_routes.dart          # 路由名稱常數
    │   └── app_pages.dart           # GetPage 清單 + 登入守衛 middleware
    └── modules/
        ├── login/                   # controllers / bindings / views
        └── dashboard/
            ├── controllers/         # dashboard / user_account
            ├── bindings/dashboard_binding.dart
            ├── views/dashboard_view.dart
            └── widgets/             # header / sidebar / main_content
                                     #  + user_account_page / pdf_preview_dialog
```

### 架構資料流

```
┌──────────────┐   呼叫    ┌──────────────┐   dio    ┌──────────────┐
│  Controller  │ ───────▶ │ AuthService  │ ───────▶ │  ApiClient   │
│ (Obx 反應式) │          │ (GetxService)│          │   (dio)      │
└──────────────┘          └──────────────┘          └──────┬───────┘
       ▲                                                    │ useMock=true
       │ Obx 自動更新 UI                                     ▼
┌──────────────┐                                  ┌──────────────────┐
│  View (GetView)                                  │ MockInterceptor  │
└──────────────┘                                  │ （回傳本地假資料）│
                                                   └──────────────────┘
```

---

## 環境需求

- Flutter SDK `3.10+`（開發驗證版本：Flutter 3.38.5 / Dart 3.x）
- Chrome（Web 開發 / 預覽）

---

## 快速開始

```bash
# 1. 安裝依賴
flutter pub get

# 2. 以 Chrome 啟動（開發模式）
flutter run -d chrome

# 3. 靜態檢查
flutter analyze

# 4. 建置正式版（產出 build/web）
flutter build web --release
```

### 登入

Mock 模式下，輸入**任意非空帳號 / 密碼**即可登入（例如 `admin` / `123456`）。
登入後會導向 `/#/dashboard`，左側選單可切換首頁 / 用戶管理 / 系統設定等頁面。

---

## Mock / 正式 API 切換

預設走本地假資料，**不需要後端就能跑**。要串接正式 API：

1. 開 `lib/app/core/values/app_constants.dart`
2. 把 `useMock` 改成 `false`：

   ```dart
   static const bool useMock = false;
   static const String apiBaseUrl = 'https://api-tnparking.tainan.gov.tw/api/v1';
   ```

關掉 Mock 後，`ApiClient` 不再掛 `MockInterceptor`，所有請求改打 `apiBaseUrl`。
service / controller 完全不用改。

> ⚠️ 從瀏覽器直接打正式 API 可能遇到 **CORS** 限制，需後端放行或透過代理。

### 新增 Mock 路由

在 `lib/app/data/providers/mock_interceptor.dart` 的 `_route()` 加一筆對應 `path`
回傳的假資料即可，不影響正式 API 行為。

---

## 與線上站的關係

線上 `tnparking.tainan.gov.tw`（內部代號 `askey_Y25_citypark_web`）由廠商以
**GetX + dio + flutter_svg + pdf_render/pdf.js + file_picker + intl** 開發。
本專案還原相同技術選型作為開發 / 練習基底，目前實作登入與後台框架，
資料層以 Mock 銜接，可隨時切換到正式 API。

---

## 功能

- **使用者帳號清單**（`基本資料作業`）：搜尋、分頁、編輯、與線上站相同的版面與配色。
- **SVG 圖示**：搜尋 / 新增 / 編輯 / 列印 / 匯入等皆使用線上站的真實 SVG（`assets/svg/`）。
- **檔案匯入**：工具列「匯入」以 file_picker 選擇 Excel / CSV。
- **PDF 預覽**：工具列「報表預覽」以 pdfrx 開啟對話框預覽 PDF（內建 `sample_report.pdf`，
  也可改成 `PdfViewer.data` 預覽匯入的檔案）。

## 已知事項

- 字型已內嵌 NotoSansTC（5 種粗細）+ Roboto，與線上站一致，無缺字方框問題。
- **pdfrx 會打包 WASM 模組**，正式建置若要縮小體積，可在 `flutter build` 前執行
  `dart run pdfrx:remove_wasm_modules`（還原用 `--revert`）。
