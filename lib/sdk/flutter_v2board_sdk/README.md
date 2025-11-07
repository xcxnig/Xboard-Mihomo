# Flutter V2Board SDK

完整的 V2Board 面板 API 封装 SDK

## 📦 安装

在主项目的 `pubspec.yaml` 中添加：

```yaml
dependencies:
  flutter_v2board_sdk:
    path: lib/sdk/flutter_v2board_sdk
```

## 🚀 快速开始

```dart
import 'package:flutter_v2board_sdk/flutter_v2board_sdk.dart';

// 1. 初始化客户端
final client = V2BoardClient(
  baseUrl: 'https://your-v2board-panel.com',
);

// 2. 登录
final success = await client.auth.login('email@example.com', 'password');

// 3. 获取用户信息
if (success) {
  final userInfo = await client.user.getUserInfo();
  print('User ID: ${userInfo.id}');
}
```

## 📚 API 模块

### 认证 (AuthApi)
- `login()` - 登录
- `register()` - 注册
- `forget()` - 忘记密码
- `sendEmailVerify()` - 发送验证码

### 用户 (UserApi)
- `getUserInfo()` - 获取用户信息
- `updateUser()` - 更新用户信息
- `changePassword()` - 修改密码
- `getSubscription()` - 获取订阅链接

### 套餐 (PlanApi)
- `getPlans()` - 获取套餐列表

### 订单 (OrderApi)
- `createOrder()` - 创建订单
- `checkout()` - 支付订单
- `getOrders()` - 获取订单列表
- `getPaymentMethods()` - 获取支付方式

### 邀请 (InviteApi)
- `getInviteInfo()` - 获取邀请信息
- `generateInviteCode()` - 生成邀请码
- `getInviteDetails()` - 获取邀请详情

### 优惠券 (CouponApi)
- `checkCoupon()` - 验证优惠券

### 公告 (NoticeApi)
- `getNotices()` - 获取公告列表

## 🏗️ 项目结构

```
lib/
├── flutter_v2board_sdk.dart    # 主入口
└── src/
    ├── v2board_client.dart     # 客户端核心
    ├── api/                    # API 模块
    │   ├── auth_api.dart
    │   ├── user_api.dart
    │   ├── plan_api.dart
    │   ├── order_api.dart
    │   ├── invite_api.dart
    │   ├── coupon_api.dart
    │   └── notice_api.dart
    ├── models/                 # 数据模型
    │   ├── api_response.dart
    │   ├── user_info.dart
    │   ├── plan.dart
    │   ├── order.dart
    │   └── ...
    ├── utils/                  # 工具类
    │   └── token_storage.dart
    └── exceptions/             # 异常类
        └── v2board_exception.dart
```

## ⚙️ 开发状态

✅ 已完成：
- SDK 基础架构
- 认证 API (AuthApi)
- Token 存储管理
- 统一响应格式

🚧 待完成（参考 XBoard SDK 实现）：
- UserApi - 用户相关 API
- PlanApi - 套餐相关 API
- OrderApi - 订单相关 API
- InviteApi - 邀请相关 API
- CouponApi - 优惠券 API
- NoticeApi - 公告 API
- 数据模型（使用 Freezed）
- 异常处理

## 📖 V2Board API 参考

基于源码：`PhpProjects/xv2b`

### API 端点

**认证：** `/api/v1/passport/auth/`
- POST `/login` - 登录
- POST `/register` - 注册
- POST `/forget` - 忘记密码

**用户：** `/api/v1/user/`
- GET `/info` - 用户信息
- POST `/update` - 更新信息
- GET `/getSubscribe` - 订阅链接

**订单：** `/api/v1/user/order/`
- POST `/save` - 创建订单
- POST `/checkout` - 支付订单
- GET `/fetch` - 订单列表

## 🔧 扩展开发

参考 `XBoardSDK` 的实现方式来完成剩余的 API 模块。

每个 API 模块的基本结构：

```dart
class UserApi {
  final Dio _dio;
  
  UserApi(this._dio);
  
  Future<ApiResponse<UserInfo>> getUserInfo() async {
    final response = await _dio.get('/api/v1/user/info');
    return ApiResponse.fromJson(response.data);
  }
}
```

## 📄 License

MIT License
