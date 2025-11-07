# Panel SDK 统一接口

多面板 SDK 支持，可在 XBoard 和 V2Board 之间无缝切换。

## 特性

✅ **统一接口**: 两种面板使用相同的 API 调用方式  
✅ **自动切换**: 根据配置文件自动选择正确的 SDK  
✅ **类型安全**: 完整的类型支持和错误处理  
✅ **简单易用**: 全局单例访问，无需手动管理实例  

## 支持的面板类型

- **XBoard**: 完整支持
- **V2Board**: 完整支持

## 快速开始

### 1. 配置面板类型

在 `assets/config/xboard.config.yaml` 中设置：

```yaml
xboard:
  # 选择面板类型
  panel_type: xboard  # 或 v2board
  
  # 其他配置...
```

### 2. 初始化 SDK

```dart
import 'package:xboard_mihomo/xboard/sdk/panel_sdk.dart';

// 从配置文件自动初始化
await PanelSDKManager.initFromConfig();

// 或手动指定
await PanelSDKManager.init(
  panelType: 'xboard',  // 或 'v2board'
  baseUrl: 'https://your-panel.com',
);
```

### 3. 使用 SDK

```dart
// 登录
final success = await PanelSDKManager.instance.login(
  email: 'user@example.com',
  password: 'password',
);

if (success) {
  print('登录成功');
}

// 获取用户信息
final userInfo = await PanelSDKManager.instance.getUserInfo();
print('用户邮箱: ${userInfo?['email']}');

// 获取订阅链接
final subUrl = await PanelSDKManager.instance.getSubscriptionUrl();
print('订阅链接: $subUrl');

// 获取套餐列表
final plans = await PanelSDKManager.instance.getPlans();
for (var plan in plans) {
  print('套餐: ${plan['name']}');
}

// 登出
await PanelSDKManager.instance.logout();
```

## API 参考

### PanelSDKManager

全局 SDK 管理器，提供单例访问。

#### 初始化

```dart
// 从配置初始化（推荐）
await PanelSDKManager.initFromConfig();

// 手动初始化
await PanelSDKManager.init(
  panelType: 'xboard',
  baseUrl: 'https://api.example.com',
  config: {
    'userAgent': 'MyApp/1.0',
    'timeout': Duration(seconds: 30),
  },
);
```

#### 属性

```dart
// 当前面板类型
String? panelType = PanelSDKManager.currentPanelType;

// 是否已初始化
bool initialized = PanelSDKManager.isInitialized;

// 是否已认证
bool authenticated = PanelSDKManager.isAuthenticated;
```

#### 方法

```dart
// 获取 SDK 实例
PanelSDKInterface sdk = PanelSDKManager.instance;

// 切换面板
await PanelSDKManager.switchPanel(
  panelType: 'v2board',
  baseUrl: 'https://new-panel.com',
);

// 释放资源
PanelSDKManager.dispose();
```

### PanelSDKInterface

统一的 SDK 接口，所有面板都实现此接口。

#### 认证相关

```dart
// 登录
bool success = await sdk.login(
  email: 'user@example.com',
  password: 'password',
);

// 登出
await sdk.logout();

// Token 管理
await sdk.saveToken('your-token');
String? token = await sdk.getToken();
await sdk.clearToken();
bool hasToken = await sdk.hasToken();
```

#### 用户相关

```dart
// 获取用户信息
Map<String, dynamic>? userInfo = await sdk.getUserInfo();

// 获取订阅链接
String? subscriptionUrl = await sdk.getSubscriptionUrl();
```

#### 套餐和订单

```dart
// 获取套餐列表
List<Map<String, dynamic>> plans = await sdk.getPlans();

// 获取订单列表
List<Map<String, dynamic>> orders = await sdk.getOrders();
```

#### 其他功能

```dart
// 获取公告列表
List<Map<String, dynamic>> notices = await sdk.getNotices();

// 获取邀请信息
Map<String, dynamic>? inviteInfo = await sdk.getInviteInfo();
```

## 切换面板

### 运行时切换

```dart
// 从 XBoard 切换到 V2Board
await PanelSDKManager.switchPanel(
  panelType: 'v2board',
  baseUrl: 'https://v2board-panel.com',
);

// 现在所有调用都会使用 V2Board SDK
final userInfo = await PanelSDKManager.instance.getUserInfo();
```

### 配置文件切换

修改 `xboard.config.yaml`:

```yaml
xboard:
  panel_type: v2board  # 从 xboard 改为 v2board
```

然后重新初始化：

```dart
await PanelSDKManager.initFromConfig();
```

## 错误处理

```dart
try {
  await PanelSDKManager.initFromConfig();
  
  final success = await PanelSDKManager.instance.login(
    email: 'user@example.com',
    password: 'password',
  );
  
  if (!success) {
    print('登录失败：用户名或密码错误');
  }
} catch (e) {
  print('SDK 错误: $e');
}
```

## 高级用法

### 自定义 Provider

如果需要自定义 SDK 行为，可以实现 `PanelSDKInterface`:

```dart
class CustomSDKProvider implements PanelSDKInterface {
  @override
  String get sdkType => 'custom';
  
  @override
  Future<void> initialize({
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    // 自定义初始化逻辑
  }
  
  // 实现其他方法...
}
```

### 直接访问底层 SDK

```dart
// 获取 XBoard SDK 实例（如果当前是 XBoard）
final provider = PanelSDKFactory.currentProvider as XBoardSDKProvider;
final xboardSdk = provider._sdk; // 访问底层 XBoardSDK

// 获取 V2Board 客户端（如果当前是 V2Board）
final provider = PanelSDKFactory.currentProvider as V2BoardSDKProvider;
final v2boardClient = provider._client; // 访问底层 V2BoardClient
```

## 架构说明

```
lib/xboard/sdk/
├── interfaces/
│   └── panel_sdk_interface.dart    # 统一接口定义
├── providers/
│   ├── xboard_sdk_provider.dart    # XBoard 适配器
│   └── v2board_sdk_provider.dart   # V2Board 适配器
├── panel_sdk_factory.dart          # SDK 工厂
├── panel_sdk_manager.dart          # 全局管理器
└── panel_sdk.dart                  # 统一导出
```

### 设计模式

- **工厂模式**: `PanelSDKFactory` 根据配置创建对应的 Provider
- **适配器模式**: 各 Provider 将不同 SDK 适配到统一接口
- **单例模式**: `PanelSDKManager` 提供全局访问点
- **策略模式**: 运行时可切换不同的 SDK 实现

## FAQ

### Q: 如何知道当前使用的是哪个 SDK？

```dart
String? panelType = PanelSDKManager.currentPanelType;
print('当前面板类型: $panelType');  // 输出: xboard 或 v2board
```

### Q: 切换面板后需要重新登录吗？

是的，切换面板会清除当前 SDK 的认证状态，需要重新登录。

### Q: 可以同时使用两个 SDK 吗？

不推荐。`PanelSDKManager` 设计为单例模式，同一时间只维护一个 SDK 实例。如果需要同时访问两个面板，请直接实例化对应的 SDK。

### Q: 如何添加新的面板支持？

1. 创建新的 Provider 类实现 `PanelSDKInterface`
2. 在 `PanelSDKFactory.createProvider()` 中添加 case 分支
3. 在配置文件中添加新的面板类型选项

## License

MIT License
