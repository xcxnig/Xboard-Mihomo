# 架构说明 - SDK 协调层设计

## 🏗️ 当前架构（3层设计）

```
┌─────────────────────────────────────────────────────────────┐
│                      主应用层 (Main App)                      │
│         lib/xboard/features/*/providers/*.dart              │
│                                                             │
│   调用方式: XBoardSDK.login(), XBoardSDK.getUserInfo()     │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   封装层 (Wrapper Layer)                     │
│              lib/xboard/sdk/xboard_sdk.dart                 │
│                                                             │
│   职责:                                                      │
│   - 提供统一的静态 API                                       │
│   - 类型别名转换                                             │
│   - 错误处理和日志                                           │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    客户端层 (Client Layer)                   │
│              lib/xboard/sdk/src/xboard_client.dart          │
│                                                             │
│   职责:                                                      │
│   - SDK 初始化                                              │
│   - 多域名管理                                               │
│   - 竞速选择                                                 │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                  原生 SDK 层 (Native SDK)                    │
│         lib/sdk/flutter_xboard_sdk/lib/src/*.dart           │
│                                                             │
│   职责:                                                      │
│   - HTTP 请求                                               │
│   - Token 管理                                              │
│   - 数据模型 (Freezed)                                      │
└─────────────────────────────────────────────────────────────┘
```

## 🔄 新架构（增加适配层）

```
┌───────────────────────────────────────────────────────────────┐
│                     主应用层 (Main App)                        │
│          lib/xboard/features/*/providers/*.dart               │
│                                                               │
│  当前: XBoardSDK.login()                                      │
│  新建议: PanelSDKManager.instance.login()                     │
└─────────────────────────┬─────────────────────────────────────┘
                          │
                          ▼
┌───────────────────────────────────────────────────────────────┐
│              🆕 统一管理层 (Unified Manager)                    │
│           lib/xboard/sdk/panel_sdk_manager.dart               │
│                                                               │
│  PanelSDKManager.instance → 根据配置返回对应 Provider         │
└─────────────────────────┬─────────────────────────────────────┘
                          │
                          ▼
┌───────────────────────────────────────────────────────────────┐
│               🆕 工厂层 (Factory Layer)                         │
│           lib/xboard/sdk/panel_sdk_factory.dart               │
│                                                               │
│  根据 panel_type 创建:                                        │
│  - xboard  → XBoardSDKProvider                               │
│  - v2board → V2BoardSDKProvider                              │
└───────────────────┬───────────────────┬───────────────────────┘
                    │                   │
         ┌──────────┘                   └──────────┐
         ▼                                         ▼
┌──────────────────────────┐        ┌──────────────────────────┐
│  🆕 XBoard 适配器         │        │  🆕 V2Board 适配器        │
│  XBoardSDKProvider        │        │  V2BoardSDKProvider       │
│                          │        │                          │
│  实现 PanelSDKInterface  │        │  实现 PanelSDKInterface  │
└────────────┬─────────────┘        └─────────────┬────────────┘
             │                                    │
             ▼                                    ▼
┌──────────────────────────┐        ┌──────────────────────────┐
│  XBoard SDK              │        │  V2Board SDK             │
│  flutter_xboard_sdk      │        │  flutter_v2board_sdk     │
└──────────────────────────┘        └──────────────────────────┘
```

## 📋 各层职责详解

### 1. 主应用层 (Main App Layer)

**位置**: `lib/xboard/features/*/providers/*.dart`

**职责**:
- 业务逻辑实现
- 状态管理 (Riverpod)
- UI 交互

**示例代码**:
```dart
// 当前方式（直接调用 XBoardSDK）
class XBoardUserAuthNotifier extends Notifier<UserAuthState> {
  Future<bool> login(String email, String password) async {
    final success = await XBoardSDK.login(email: email, password: password);
    return success;
  }
}
```

**建议新方式**:
```dart
// 新方式（通过 PanelSDKManager）
class XBoardUserAuthNotifier extends Notifier<UserAuthState> {
  Future<bool> login(String email, String password) async {
    final success = await PanelSDKManager.instance.login(
      email: email, 
      password: password
    );
    return success;
  }
}
```

### 2. 封装层 (Wrapper Layer)

**位置**: `lib/xboard/sdk/xboard_sdk.dart`

**职责**:
- 提供向后兼容的静态 API
- 类型别名转换（`UserInfoData = sdk.UserInfo`）
- 统一错误处理和日志

**特点**:
- 静态类，全局访问
- 对业务代码透明
- 简化 API 调用

**示例**:
```dart
class XBoardSDK {
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _sdk.loginWithCredentials(email, password);
  }
}
```

### 3. 客户端层 (Client Layer)

**位置**: `lib/xboard/sdk/src/xboard_client.dart`

**职责**:
- SDK 初始化管理
- 多域名管理和切换
- 竞速选择最快域名

**特点**:
- 单例模式
- 管理 SDK 生命周期
- 配置提供者接口

### 4. 🆕 统一管理层 (Unified Manager)

**位置**: `lib/xboard/sdk/panel_sdk_manager.dart`

**职责**:
- 全局单例访问点
- 自动根据配置选择 Provider
- 简化多面板切换

**示例**:
```dart
class PanelSDKManager {
  static PanelSDKInterface get instance {
    return PanelSDKFactory.currentProvider;
  }
  
  static Future<void> initFromConfig() async {
    await PanelSDKFactory.createFromConfig();
  }
}
```

### 5. 🆕 工厂层 (Factory Layer)

**位置**: `lib/xboard/sdk/panel_sdk_factory.dart`

**职责**:
- 根据 `panel_type` 创建对应 Provider
- 管理 Provider 生命周期
- 支持运行时切换

**示例**:
```dart
class PanelSDKFactory {
  static Future<PanelSDKInterface> createProvider({
    required String panelType,
    required String baseUrl,
  }) async {
    switch (panelType) {
      case 'xboard':
        return XBoardSDKProvider();
      case 'v2board':
        return V2BoardSDKProvider();
    }
  }
}
```

### 6. 🆕 适配器层 (Adapter Layer)

**位置**: `lib/xboard/sdk/providers/*_sdk_provider.dart`

**职责**:
- 实现 `PanelSDKInterface` 统一接口
- 将各自 SDK 适配到相同 API
- 数据模型转换

**XBoard 适配器示例**:
```dart
class XBoardSDKProvider implements PanelSDKInterface {
  XBoardSDK? _sdk;
  
  @override
  Future<bool> login({required String email, required String password}) async {
    return await _sdk!.loginWithCredentials(email, password);
  }
  
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    final response = await _sdk!.userInfo.getUserInfo();
    return response.data?.toJson();
  }
}
```

**V2Board 适配器示例**:
```dart
class V2BoardSDKProvider implements PanelSDKInterface {
  V2BoardClient? _client;
  
  @override
  Future<bool> login({required String email, required String password}) async {
    final response = await _client!.auth.login(email: email, password: password);
    return response.success;
  }
  
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    final response = await _client!.user.getUserInfo();
    return response.data?.toJson();
  }
}
```

### 7. 原生 SDK 层 (Native SDK Layer)

**XBoard SDK 位置**: `lib/sdk/flutter_xboard_sdk/`  
**V2Board SDK 位置**: `lib/sdk/flutter_v2board_sdk/`

**职责**:
- 直接的 HTTP 请求
- Token 存储和管理
- 数据模型定义 (Freezed)
- API 响应解析

## 🔄 数据流向

### 登录流程示例

```
1. 用户点击登录按钮
   ↓
2. LoginPage 调用 Provider
   userAuthProvider.login(email, password)
   ↓
3. XBoardUserAuthNotifier
   await PanelSDKManager.instance.login(email, password)
   ↓
4. PanelSDKManager
   返回当前 Provider (XBoardSDKProvider 或 V2BoardSDKProvider)
   ↓
5. Provider (例如 XBoardSDKProvider)
   await _sdk!.loginWithCredentials(email, password)
   ↓
6. XBoard SDK (flutter_xboard_sdk)
   POST /api/v1/passport/auth/login
   ↓
7. 返回响应，逆向传递
   Response → SDK → Provider → Manager → Notifier → UI
```

## 🎯 迁移策略

### 阶段 1: 保持兼容 ✅ (当前)

```dart
// 主应用继续使用 XBoardSDK
await XBoardSDK.login(email: email, password: password);

// XBoardSDK 内部已经存在，不需要修改
```

### 阶段 2: 引入适配层 ✅ (已完成)

```dart
// 新增 PanelSDKManager，但不强制使用
await PanelSDKManager.instance.login(email: email, password: password);

// XBoardSDK 继续可用，向后兼容
```

### 阶段 3: 渐进式迁移 (可选)

```dart
// 逐步将 XBoardSDK 替换为 PanelSDKManager
// 例如：先迁移认证模块
class XBoardUserAuthNotifier {
  // Old: await XBoardSDK.login(...)
  // New: 
  await PanelSDKManager.instance.login(...);
}
```

### 阶段 4: 统一接口 (未来)

```dart
// 完全移除 XBoardSDK，只使用 PanelSDKManager
// 主应用不再关心底层是 XBoard 还是 V2Board
```

## 📊 配置驱动的切换

### 配置文件 (`xboard.config.yaml`)

```yaml
xboard:
  # 面板类型选择
  panel_type: xboard  # 或 v2board
  
  # XBoard 配置
  provider: Flclash
  remote_config:
    sources:
      - name: redirect
        url: https://xboard-domain.com/config.json
        
  # V2Board 配置 (当 panel_type = v2board 时使用)
  v2board_url: https://v2board-domain.com
```

### 运行时切换

```dart
// 从配置自动初始化
await PanelSDKManager.initFromConfig();

// 当前使用的面板类型
print(PanelSDKManager.currentPanelType); // 'xboard' 或 'v2board'

// 手动切换
await PanelSDKManager.switchPanel(
  panelType: 'v2board',
  baseUrl: 'https://new-panel.com',
);
```

## ✨ 优势总结

### 1. 解耦合
- 主应用不依赖具体 SDK
- 通过接口编程

### 2. 灵活性
- 配置文件控制面板类型
- 运行时可切换

### 3. 可维护性
- 统一的接口规范
- 清晰的分层架构

### 4. 可扩展性
- 轻松添加新面板支持
- 只需实现 `PanelSDKInterface`

### 5. 向后兼容
- `XBoardSDK` 仍然可用
- 渐进式迁移

## 🚀 使用建议

### 新项目
```dart
// 直接使用 PanelSDKManager
await PanelSDKManager.initFromConfig();
await PanelSDKManager.instance.login(...);
```

### 现有项目
```dart
// 两种方式并存
// 方式 1: 继续使用 XBoardSDK (不需要改代码)
await XBoardSDK.login(...);

// 方式 2: 逐步迁移到 PanelSDKManager (支持多面板)
await PanelSDKManager.instance.login(...);
```

## 📝 总结

当前架构已经**完全实现了多面板支持**，但为了**向后兼容**，保留了原有的 `XBoardSDK` 静态类。

**主应用层**可以选择：
1. 继续使用 `XBoardSDK`（简单，但只支持 XBoard）
2. 迁移到 `PanelSDKManager`（灵活，支持多面板切换）

**两种方式可以共存**，根据业务需要逐步迁移。

---

最后更新: 2025-11-07

