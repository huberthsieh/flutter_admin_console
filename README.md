# Flutter Admin Console

一個使用 Flutter + CanvasKit + go_router 構建的現代化後台管理系統。

## 功能特色

- **登入驗證**: 簡單的登入系統
- **響應式設計**: 支援桌面和移動設備
- **現代化 UI**: 參考 Bootstrap 的設計風格
- **CanvasKit 渲染**: 使用 CanvasKit 提供更好的 Web 性能
- **路由管理**: 使用 go_router 進行頁面導航
- **多頁面支援**:
  - 首頁儀表板
  - 用戶管理
  - 系統設定
  - 更多頁面（可擴展）

## 專案結構

```
lib/
├── main.dart                          # 應用程式入口點
├── router/
│   └── app_router.dart               # 路由配置
├── services/
│   └── auth_service.dart             # 認證服務
├── screens/
│   ├── login_screen.dart             # 登入頁面
│   └── dashboard/
│       ├── dashboard_screen.dart     # 後台主頁面
│       └── widgets/
│           ├── header.dart           # 頂部導航
│           ├── sidebar.dart          # 側邊選單
│           └── main_content.dart     # 主要內容區
└── web/
    └── index.html                    # Web 配置（CanvasKit）
```

## 技術棧

- **Flutter**: 跨平台 UI 框架
- **go_router**: 聲明式路由管理
- **shared_preferences**: 本地數據存儲
- **CanvasKit**: Web 渲染引擎

## 開始使用

### 安裝依賴

```bash
flutter pub get
```

### 運行專案

#### Web 開發模式

```bash
flutter run -d chrome
```

註：Flutter 3.38+ 版本會自動使用 `web/index.html` 中配置的 CanvasKit 渲染器。

#### 構建生產版本

```bash
flutter build web
```

### 登入說明

目前登入頁面接受任意帳號密碼組合（示範用途）。只要帳號和密碼欄位不為空即可登入。

在實際生產環境中，您需要：
1. 實作真實的後端 API
2. 在 `lib/services/auth_service.dart` 中連接您的認證 API
3. 添加適當的錯誤處理和驗證邏輯

## 介面預覽

### 登入頁面
- 漸層背景設計
- 卡片式登入表單
- 表單驗證

### 後台儀表板
- **Header**:
  - Logo 和標題
  - 搜尋功能
  - 通知中心
  - 用戶選單（含登出功能）

- **Sidebar**:
  - 深色主題
  - 選單項目高亮顯示
  - 響應式設計（移動設備上自動收合）

- **主要內容區**:
  - 統計卡片
  - 數據圖表區域
  - 用戶管理表格
  - 設定頁面

## 自定義與擴展

### 添加新頁面

1. 在 `lib/router/app_router.dart` 添加新路由
2. 在 `lib/screens/dashboard/widgets/sidebar.dart` 添加選單項目
3. 在 `lib/screens/dashboard/widgets/main_content.dart` 添加頁面內容

### 修改主題

在 `lib/main.dart` 中修改 `ThemeData` 配置：

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue, // 修改主色調
    brightness: Brightness.light,
  ),
  // 其他主題配置...
)
```

### 連接後端 API

修改 `lib/services/auth_service.dart`：

```dart
Future<bool> login(String username, String password) async {
  // 替換為您的 API 呼叫
  final response = await http.post(
    Uri.parse('https://your-api.com/login'),
    body: {'username': username, 'password': password},
  );

  if (response.statusCode == 200) {
    // 處理成功的登入邏輯
    return true;
  }
  return false;
}
```

## CanvasKit 配置

專案已配置使用 CanvasKit 渲染器以獲得最佳的 Web 性能。配置位於 `web/index.html`。

### 優點
- 更好的性能
- 一致的跨平台渲染
- 支援更多 Flutter 功能

### 注意事項
- 初始載入時間可能稍長（首次需下載 CanvasKit）
- 檔案大小較大

如需暫時切換到 HTML 渲染器，需修改 `web/index.html` 中的渲染器設定，將 `renderer: "canvaskit"` 改為 `renderer: "html"`。

## 響應式設計

系統支援多種螢幕尺寸：

- **桌面** (>= 768px): 顯示完整的 Sidebar
- **平板/手機** (< 768px): Sidebar 收合為抽屜式選單

## 開發建議

1. **狀態管理**: 目前使用簡單的 StatefulWidget，大型專案建議使用 Provider、Riverpod 或 Bloc
2. **API 整合**: 建議使用 dio 或 http 套件進行 API 呼叫
3. **表單驗證**: 可考慮使用 flutter_form_builder 或 formz
4. **國際化**: 可使用 flutter_localizations 支援多語言

## 授權

此專案為示範用途，可自由使用和修改。

## 聯絡方式

如有任何問題或建議，歡迎提出 Issue。
