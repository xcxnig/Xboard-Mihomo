# Flutter V2Board SDK

Flutter SDK for V2Board panel API integration.

## 功能特性

✅ **用户认证**
- 登录 / 注册
- Token 管理
- 自动续期

✅ **用户管理**
- 获取用户信息
- 更新用户设置
- 流量统计
- 订阅链接管理

✅ **套餐管理**
- 获取套餐列表
- 套餐详情
- 价格查询

✅ **订单管理**
- 创建订单
- 支付处理
- 订单状态查询
- 订单历史

✅ **优惠券**
- 优惠券验证
- 折扣计算

✅ **邀请系统**
- 邀请码生成
- 邀请统计
- 佣金管理

✅ **公告管理**
- 获取公告列表
- 公告详情

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter_v2board_sdk:
    path: lib/sdk/flutter_v2board_sdk
```

## 快速开始

### 1. 初始化客户端

```dart
import 'package:flutter_v2board_sdk/flutter_v2board_sdk.dart';

// 创建客户端实例
final client = V2BoardClient(
  baseUrl: 'https://your-v2board-panel.com',
);
```

### 2. 用户认证

```dart
// 登录
final loginResponse = await client.auth.login(
  email: 'user@example.com',
  password: 'password',
);

if (loginResponse.success && loginResponse.data != null) {
  final authToken = loginResponse.data!;
  print('登录成功: $authToken');
}

// 检查登录状态
final isLoggedIn = await client.isAuthenticated;
```

### 3. 获取用户信息

```dart
final userResponse = await client.user.getUserInfo();

if (userResponse.success && userResponse.data != null) {
  final user = userResponse.data!;
  print('用户邮箱: ${user.email}');
  print('剩余流量: ${user.remainingTraffic} bytes');
  print('流量使用率: ${user.trafficUsagePercent}%');
}
```

### 4. 获取套餐列表

```dart
final plansResponse = await client.plan.getPlans();

if (plansResponse.success) {
  final plans = plansResponse.data ?? [];
  for (var plan in plans) {
    print('套餐名称: ${plan.name}');
    print('月付价格: ${plan.monthPrice}');
    print('流量: ${plan.transferGB} GB');
  }
}
```

### 5. 创建订单

```dart
// 创建订单
final orderResponse = await client.order.createOrder(
  planId: 1,
  period: 'month_price',
  couponCode: 'DISCOUNT20',  // 可选
);

if (orderResponse.success && orderResponse.data != null) {
  final tradeNo = orderResponse.data!;
  
  // 提交支付
  final checkoutResponse = await client.order.checkout(
    tradeNo: tradeNo,
    method: 1,  // 支付方式 ID
  );
}
```

### 6. 邀请系统

```dart
// 获取邀请信息
final inviteResponse = await client.invite.getInviteInfo();

if (inviteResponse.success && inviteResponse.data != null) {
  final inviteInfo = inviteResponse.data!;
  
  // 邀请码列表
  final codes = inviteInfo.codes ?? [];
  for (var code in codes) {
    print('邀请码: ${code.code}');
  }
  
  // 邀请统计
  final stats = inviteInfo.stat ?? [];
  for (var stat in stats) {
    print('注册人数: ${stat.registerCount}');
    print('佣金余额: ${stat.commissionBalance}');
  }
}
```

## API 模块

### AuthApi
- `login(email, password)` - 用户登录

### UserApi
- `getUserInfo()` - 获取用户信息
- `getSubscription()` - 获取订阅链接
- `updateUser()` - 更新用户设置
- `changePassword()` - 修改密码
- `transferCommission()` - 佣金划转

### PlanApi
- `getPlans()` - 获取套餐列表
- `getPlan(planId)` - 获取单个套餐详情

### OrderApi
- `createOrder()` - 创建订单
- `checkout()` - 提交支付
- `checkOrder()` - 检查订单状态
- `getOrderDetail()` - 获取订单详情
- `getOrders()` - 获取订单列表
- `getPaymentMethods()` - 获取支付方式列表
- `cancelOrder()` - 取消订单

### CouponApi
- `checkCoupon()` - 验证优惠券

### InviteApi
- `getInviteInfo()` - 获取邀请信息
- `generateInviteCode()` - 生成邀请码
- `getInviteDetails()` - 获取邀请详情

### NoticeApi
- `getNotices()` - 获取公告列表

## 数据模型

所有数据模型都提供了便捷的属性和方法：

- **UserInfo**: 用户信息，包含流量计算、过期状态等
- **Plan**: 套餐信息，支持价格查询
- **Order**: 订单信息，包含状态判断
- **Coupon**: 优惠券，支持折扣计算
- **InviteInfo**: 邀请信息和统计

## 错误处理

```dart
try {
  final response = await client.user.getUserInfo();
  
  if (response.success) {
    // 成功处理
  } else {
    // 失败处理
    print('错误: ${response.message}');
  }
} on V2BoardException catch (e) {
  print('V2Board 错误: ${e.message}');
  print('状态码: ${e.statusCode}');
} catch (e) {
  print('其他错误: $e');
}
```

## License

MIT License
