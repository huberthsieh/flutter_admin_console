# CLAUDE.md — flutter_admin_console（停車營運管理系統）

> 本檔只放「本專案特有」規則；通則（commit 格式、扁平化、註解 WHY、溝通用語等）
> 以全域 `~/.claude/CLAUDE.md` 為準，這裡不重複。

---

## 專案定位

Flutter Web 後台管理系統，技術選型對齊線上正式站
`tnparking.tainan.gov.tw`：**Flutter + CanvasKit + GetX + dio**。
資料層預設走本地 Mock，可一鍵切換到正式 API。

---

## 架構慣例（重要）

採 GetX 標準模組結構。**新增功能時照同一套擺放，不要自創目錄。**

```
lib/app/
├── core/
│   ├── theme/      # 配色、字型等全站樣式（app_colors.dart）
│   └── values/     # 常數、設定（app_constants.dart）
├── data/
│   ├── models/     # 純資料模型（data class + fromJson）
│   ├── providers/  # dio client、攔截器等對外資料來源
│   └── services/   # GetxService：跨頁共用狀態（如 auth）
├── routes/         # app_routes.dart（名稱常數）、app_pages.dart（GetPage + middleware）
└── modules/<功能>/
    ├── controllers/  # GetxController：該頁的狀態與邏輯
    ├── bindings/     # 該頁的依賴注入
    ├── views/        # 主畫面（GetView<Controller>）
    └── widgets/      # 該頁專屬的子元件
```

規則：

- 一個畫面 = 一個 module。畫面狀態放 `controller`，UI 放 `view`，依賴在 `binding` 注入。
- View 用 `GetView<T>`，透過 `controller` 取狀態；需要響應式更新的區塊用 `Obx(() => ...)`。
- 跨頁、需常駐的狀態（登入、設定）才放 `data/services` 的 `GetxService`；
  單一畫面的狀態放該 module 的 controller，不要塞進 service。
- 路由一律用 `Routes.xxx` 常數（`app_routes.dart`），不要散落字串。
- 需要登入保護的頁掛 middleware（見 `app_pages.dart`）。

---

## GetX 隔離（降低未來替換成本）

GetX 繞過 Flutter 原生設計、且維護由單一作者主導（2026/04 曾發生 repo 一度消失
的事件）。本專案現階段用它換取開發速度，但要刻意把它「圈」在固定幾層，
讓將來若需替換不致牽動整個專案。

- **導頁集中**：不要在各頁直接呼叫 `Get.toNamed` / `Get.offAllNamed` / `Get.back`。
  一律經過單一封裝（如 `core/navigation/app_nav.dart`），內部才呼叫 GetX。
  要換路由方案時只改這一個檔。
- **controller / service 盡量不依賴 GetX 特有 API**：邏輯與資料流寫成一般 Dart，
  GetX 的東西（`.obs`、`Get.find`）集中在邊界。理想上 controller 換個狀態方案
  時主體邏輯可保留。
- **GetX 綁定只出現在 view 層**：`GetView` / `Obx` 只在 `views/` 與 `widgets/` 用，
  不要滲進 `data/`。
- 不要用 GetX 的雜項工具（`Get.snackbar` 以外的 `GetUtils`、`.tr`、`GetStorage` 等）
  擴大依賴面；該用 Flutter / 既有套件能做的就用原生。

---

## 資料層 / API

- 是否連真後端由 `AppConstants.useMock` 決定：
  - `true`（預設）→ `ApiClient` 掛 `MockInterceptor`，回傳本地假資料，不連線。
  - `false` → 改打 `AppConstants.apiBaseUrl`（正式站 API）。
- service / controller **不應該知道現在是不是 Mock**；切換只動 `AppConstants` 與攔截器。
- **新增一支 API 時，同步在 `mock_interceptor.dart` 補對應的 mock route**，
  否則 Mock 模式下該功能會 404。
- 錯誤處理：讓 `DioException` 往上拋到 controller，由 controller 轉成畫面狀態
  （error message / snackbar）。不要在 service 層 catch 後吞掉。

---

## 樣式

- 顏色一律從 `app_colors.dart` 取，不要在 widget 裡寫死 hex。
  - 主色 `#155AD3`、側欄深色 `#1F2032`（已定義為 `AppColors.primary` / `sidebarBg`）。
- 字型用內嵌的 `NotoSansTC`（已設為預設 fontFamily），不要再引入其他中文字型。
- 圖示優先用 `assets/svg/` 既有的真實 SVG（`flutter_svg`）；
  需要改色用 `ColorFilter.mode(..., BlendMode.srcIn)`。

---

## Flutter 踩過的坑

- `Container(alignment: ...)` 若**沒給固定寬高**，在寬鬆約束下會撐滿可用空間。
  要固定尺寸的方塊（分頁鈕、icon 容器）請明確給 `width`/`height`。
- `web/index.html` 只用 `flutter_bootstrap.js` 一套載入器，
  載入畫面靠 `flutter-first-frame` 事件移除。**不要再加 `_flutter.loader.load`**，
  兩套並存會在重載時卡住或黑屏。
- CanvasKit 沒有真正的 DOM 元件，自動化測試點不到 widget；
  驗證互動要用實機鍵鼠（或啟用 semantics 後操作）。

---

## 常用指令

```bash
flutter run -d chrome          # 開發（Chrome）
flutter analyze                # 靜態檢查（送出前必過）
flutter build web --release    # 正式建置
dart run pdfrx:remove_wasm_modules   # build 前可選：移除 pdfrx WASM 縮小體積（--revert 還原）
```

---

## 修改範圍

- 改 UI 後實際在瀏覽器跑過再宣稱完成；`analyze` 只驗證程式正確，不驗證畫面正確。
- 動 `pubspec.yaml`（套件 / 字型 / 資產）後要重新 `flutter run`，hot reload 不會生效。
