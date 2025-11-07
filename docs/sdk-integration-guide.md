# SDK 集成指南

本指南介绍如何在应用中集成和使用多面板 SDK 支持。

## 📋 目录

- [功能概述](#功能概述)
- [架构说明](#架构说明)
- [快速开始](#快速开始)
- [配置说明](#配置说明)
- [API 参考](#api-参考)
- [最佳实践](#最佳实践)
- [故障排除](#故障排除)

## 功能概述

### ✨ 主要特性

- ✅ **多面板支持**: 同时支持 XBoard 和 V2Board 两种面板
- ✅ **统一接口**: 两种面板使用相同的 API 调用方式
- ✅ **自动切换**: 根据配置文件自动选择正确的 SDK
- ✅ **运行时切换**: 支持在运行时动态切换面板类型
- ✅ **类型安全**: 完整的 Dart 类型支持和 null safety
- ✅ **错误处理**: 统一的异常处理机制

### 🎯 支持的面板

| 面板类型 | SDK 状态 | 功能完整度 |
|---------|---------|-----------|
| XBoard  | ✅ 完全支持 | 100% |
| V2Board | ✅ 完全支持 | 100% |

## 架构说明

### 设计模式

```
┌─────────────────────────────────────┐
│      PanelSDKManager (单例)         │
│   全局访问点，简化 SDK 调用           │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│      PanelSDKFactory (工厂)         │
│   根据配置创建对应的 Provider         │
└────────────┬────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
┌─────▼─────┐ ┌────▼──────┐
│ XBoard    │ │ V2Board   │
│ Provider  │ │ Provider  │
│ (适配器)  │ │ (适配器)  │
└─────┬─────┘ └────┬──────┘
      │             │
┌─────▼─────┐ ┌────▼──────┐
│ XBoard    │ │ V2Board   │
│ SDK       │ │ SDK       │
└───────────┘ └───────────┘
```

### 核心组件

#### 1. PanelSDKInterface (统一接口)

定义了所有面板 SDK 必须实现的通用方法。

```dart
abstract class PanelSDKInterface {
  String get sdkType;
  bool get isInitialized;
  bool get isAuthenticated;
  
  Future<void> initialize({required String baseUrl, ...});
  Future<bool> login({required String email, ...});
  Future<Map<String, dynamic>?> getUserInfo();
  // ... 更多方法
}
```

#### 2. XBoardSDKProvider / V2BoardSDKProvider (适配器)

将各自的 SDK 适配到统一接口。

```dart
class XBoardSDKProvider implements PanelSDKInterface {
  XBoardSDK? _sdk;
  
  @override
  Future<void> initialize({required String baseUrl, ...}) async {
    _sdk = XBoardSDK.instance;
    await _sdk!.initialize(baseUrl);
  }
  
  // 实现其他接口方法...
}
```

#### 3. PanelSDKFactory (工厂类)

根据 `panel_type` 配置创建对应的 Provider。

```dart
class PanelSDKFactory {
  static Future<PanelSDKInterface> createProvider({
    required String panelType,
    required String baseUrl,
  }) async {
    switch (panelType) {
      case 'xboard': return XBoardSDKProvider();
      case 'v2board': return V2BoardSDKProvider();
    }
  }
}
```

#### 4. PanelSDKManager (全局管理器)

提供单例访问，简化 SDK 使用。

```dart
class PanelSDKManager {
  static PanelSDKInterface get instance { ... }
  static Future<void> initFromConfig() async { ... }
  static Future<void> switchPanel(...) async { ... }
}
```

## 快速开始

### 步骤 1: 配置面板类型

编辑 `assets/config/xboard.config.yaml`:

```yaml
xboard:
  # 选择面板类型（必填）
  panel_type: xboard  # 可选值: xboard, v2board
  
  # 其他配置保持不变...
```

### 步骤 2: 初始化 SDK

在应用启动时初始化 SDK：

```dart
import 'package:xboard_mihomo/xboard/sdk/panel_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化 SDK（自动读取配置）
  await PanelSDKManager.initFromConfig();
  
  runApp(MyApp());
}
```

### 步骤 3: 使用 SDK

在任何地方调用 SDK 方法：

```dart
// 登录
final success = await PanelSDKManager.instance.login(
  email: 'user@example.com',
  password: 'password',
);

// 获取用户信息
final userInfo = await PanelSDKManager.instance.getUserInfo();

// 获取订阅链接
final subscriptionUrl = await PanelSDKManager.instance.getSubscriptionUrl();
```

## 配置说明

### 配置文件结构

```yaml
xboard:
  # ==================== 面板类型配置 ====================
  # panel_type: 面板类型选择
  #   - xboard: 使用 XBoard 面板系统和对应 SDK
  #   - v2board: 使用 V2Board 面板系统和对应 SDK
  # 
  # ⚠️ 重要：系统会根据此配置自动加载对应的 SDK
  # ==========================================
  panel_type: xboard
  
  # 后端提供商类型（与 config.json 中的 panels 键对应）
  provider: Flclash
  
  # 远程配置源（主源）
  remote_config:
    sources:
      - name: redirect
        url: https://your-domain.com/config.json
        priority: 100
```

### 配置项说明

| 配置项 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| `panel_type` | string | ✅ | 面板类型：`xboard` 或 `v2board` |
| `provider` | string | ✅ | 提供商名称，用于匹配 config.json 中的面板配置 |
| `remote_config` | object | ✅ | 远程配置源信息 |

## API 参考

### 初始化

#### initFromConfig()

从配置文件自动初始化（推荐）。

```dart
await PanelSDKManager.initFromConfig();
```

#### init()

手动指定参数初始化。

```dart
await PanelSDKManager.init(
  panelType: 'xboard',
  baseUrl: 'https://your-panel.com',
  config: {
    'userAgent': 'MyApp/1.0',
    'timeout': Duration(seconds: 30),
  },
);
```

### 认证相关

#### login()

用户登录。

```dart
final success = await PanelSDKManager.instance.login(
  email: 'user@example.com',
  password: 'password123',
);

if (success) {
  print('登录成功');
}
```

#### logout()

用户登出。

```dart
await PanelSDKManager.instance.logout();
```

#### Token 管理

```dart
// 保存 Token
await PanelSDKManager.instance.saveToken('your-token');

// 获取 Token
String? token = await PanelSDKManager.instance.getToken();

// 清除 Token
await PanelSDKManager.instance.clearToken();

// 检查是否有 Token
bool hasToken = await PanelSDKManager.instance.hasToken();
```

### 用户信息

#### getUserInfo()

获取用户信息。

```dart
final userInfo = await PanelSDKManager.instance.getUserInfo();

if (userInfo != null) {
  print('邮箱: ${userInfo['email']}');
  print('流量: ${userInfo['transfer_enable']}');
  print('过期时间: ${userInfo['expired_at']}');
}
```

#### getSubscriptionUrl()

获取订阅链接。

```dart
final subscriptionUrl = await PanelSDKManager.instance.getSubscriptionUrl();
print('订阅链接: $subscriptionUrl');
```

### 套餐和订单

#### getPlans()

获取套餐列表。

```dart
final plans = await PanelSDKManager.instance.getPlans();

for (var plan in plans) {
  print('${plan['name']}: ${plan['month_price']} 元/月');
}
```

#### getOrders()

获取订单列表。

```dart
final orders = await PanelSDKManager.instance.getOrders();

for (var order in orders) {
  print('订单号: ${order['trade_no']}');
  print('状态: ${order['status']}');
}
```

### 其他功能

#### getNotices()

获取公告列表。

```dart
final notices = await PanelSDKManager.instance.getNotices();

for (var notice in notices) {
  print('${notice['title']}: ${notice['content']}');
}
```

#### getInviteInfo()

获取邀请信息。

```dart
final inviteInfo = await PanelSDKManager.instance.getInviteInfo();

if (inviteInfo != null) {
  final codes = inviteInfo['codes'] as List?;
  final stats = inviteInfo['stat'] as List?;
  
  // 处理邀请码和统计数据
}
```

## 最佳实践

### 1. 错误处理

始终使用 try-catch 包裹 SDK 调用：

```dart
try {
  final success = await PanelSDKManager.instance.login(
    email: email,
    password: password,
  );
  
  if (success) {
    // 登录成功处理
  } else {
    // 登录失败处理（凭据错误）
  }
} catch (e) {
  // 异常处理（网络错误、SDK 未初始化等）
  print('登录异常: $e');
}
```

### 2. 初始化检查

在调用 SDK 前检查初始化状态：

```dart
if (!PanelSDKManager.isInitialized) {
  await PanelSDKManager.initFromConfig();
}

// 现在可以安全调用
final userInfo = await PanelSDKManager.instance.getUserInfo();
```

### 3. 认证状态检查

在需要认证的操作前检查状态：

```dart
if (!PanelSDKManager.isAuthenticated) {
  // 跳转到登录页面
  Navigator.pushNamed(context, '/login');
  return;
}

// 已认证，继续操作
final orders = await PanelSDKManager.instance.getOrders();
```

### 4. 资源清理

在应用退出时清理资源：

```dart
@override
void dispose() {
  PanelSDKManager.dispose();
  super.dispose();
}
```

### 5. 面板切换

如需切换面板，先登出再切换：

```dart
// 登出当前面板
await PanelSDKManager.instance.logout();

// 切换到新面板
await PanelSDKManager.switchPanel(
  panelType: 'v2board',
  baseUrl: 'https://new-panel.com',
);

// 重新登录
await PanelSDKManager.instance.login(...);
```

## 故障排除

### 问题 1: SDK 未初始化错误

**错误信息**:
```
PanelSDKManager not initialized. Call PanelSDKManager.initFromConfig() first.
```

**解决方法**:
```dart
// 在使用 SDK 前先初始化
await PanelSDKManager.initFromConfig();
```

### 问题 2: 配置文件未找到

**错误信息**:
```
XBoardConfig not initialized. Call XBoardConfig.init() first.
```

**解决方法**:
```dart
// 确保 XBoardConfig 已初始化
import 'package:xboard_mihomo/xboard/config/xboard_config.dart';

await XBoardConfig.init();
await PanelSDKManager.initFromConfig();
```

### 问题 3: 不支持的面板类型

**错误信息**:
```
Unsupported panel type: xxx. Supported types: xboard, v2board
```

**解决方法**:

检查 `xboard.config.yaml` 中的 `panel_type` 配置是否正确：

```yaml
xboard:
  panel_type: xboard  # 只能是 xboard 或 v2board
```

### 问题 4: 登录失败

**可能原因**:
1. 用户名或密码错误
2. 网络连接问题
3. 面板 URL 配置错误
4. Token 过期

**调试步骤**:

```dart
try {
  final success = await PanelSDKManager.instance.login(
    email: email,
    password: password,
  );
  
  if (!success) {
    // 检查凭据是否正确
    print('登录失败：用户名或密码错误');
  }
} catch (e) {
  // 检查网络或配置问题
  print('登录异常: $e');
  
  // 检查当前面板类型和 URL
  print('面板类型: ${PanelSDKManager.currentPanelType}');
}
```

### 问题 5: 数据获取失败

**调试步骤**:

1. 检查认证状态：
```dart
print('是否已认证: ${PanelSDKManager.isAuthenticated}');
```

2. 检查 Token：
```dart
final token = await PanelSDKManager.instance.getToken();
print('Token: $token');
```

3. 检查网络连接和面板 URL

## 更多资源

- [Panel SDK README](../lib/xboard/sdk/README.md) - 详细的 API 文档
- [使用示例](../lib/xboard/sdk/examples/panel_sdk_example.dart) - 完整的代码示例
- [快速开始指南](./quick-start.md) - 应用快速配置
- [构建指南](./build-guide.md) - 完整的构建流程

## 获取帮助

如有问题，请：

1. 查看 [FAQ](#故障排除) 部分
2. 阅读[示例代码](../lib/xboard/sdk/examples/panel_sdk_example.dart)
3. 加入 [Telegram 群组](https://t.me/V2Hiidify) 寻求帮助

---

最后更新: 2025-11-07

