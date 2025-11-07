/// Panel SDK 使用示例
/// 
/// 展示如何使用统一的 SDK 接口在 XBoard 和 V2Board 之间切换

import '../panel_sdk.dart';

/// 示例 1: 从配置文件初始化
/// 
/// 这是最推荐的方式，SDK 会自动读取 xboard.config.yaml 中的配置
Future<void> example1_initFromConfig() async {
  print('=== 示例 1: 从配置文件初始化 ===');
  
  try {
    // 初始化 SDK（自动读取配置文件）
    await PanelSDKManager.initFromConfig();
    
    print('✅ SDK 初始化成功');
    print('当前面板类型: ${PanelSDKManager.currentPanelType}');
    print('是否已认证: ${PanelSDKManager.isAuthenticated}');
  } catch (e) {
    print('❌ 初始化失败: $e');
  }
}

/// 示例 2: 手动指定面板类型初始化
/// 
/// 适用于需要动态指定面板类型的场景
Future<void> example2_manualInit() async {
  print('\n=== 示例 2: 手动初始化 ===');
  
  try {
    // 初始化为 XBoard
    await PanelSDKManager.init(
      panelType: 'xboard',
      baseUrl: 'https://your-xboard-panel.com',
      config: {
        'userAgent': 'MyApp/1.0',
        'timeout': const Duration(seconds: 30),
      },
    );
    
    print('✅ XBoard SDK 初始化成功');
  } catch (e) {
    print('❌ 初始化失败: $e');
  }
}

/// 示例 3: 用户登录和基本操作
Future<void> example3_loginAndBasicOperations() async {
  print('\n=== 示例 3: 登录和基本操作 ===');
  
  try {
    // 确保 SDK 已初始化
    if (!PanelSDKManager.isInitialized) {
      await PanelSDKManager.initFromConfig();
    }
    
    // 登录
    final success = await PanelSDKManager.instance.login(
      email: 'user@example.com',
      password: 'password123',
    );
    
    if (success) {
      print('✅ 登录成功');
      
      // 获取用户信息
      final userInfo = await PanelSDKManager.instance.getUserInfo();
      if (userInfo != null) {
        print('用户邮箱: ${userInfo['email']}');
        print('剩余流量: ${userInfo['transfer_enable']} bytes');
      }
      
      // 获取订阅链接
      final subUrl = await PanelSDKManager.instance.getSubscriptionUrl();
      print('订阅链接: $subUrl');
      
      // 登出
      await PanelSDKManager.instance.logout();
      print('✅ 已登出');
    } else {
      print('❌ 登录失败：用户名或密码错误');
    }
  } catch (e) {
    print('❌ 操作失败: $e');
  }
}

/// 示例 4: 获取套餐和订单信息
Future<void> example4_getPlansAndOrders() async {
  print('\n=== 示例 4: 获取套餐和订单 ===');
  
  try {
    // 获取套餐列表
    final plans = await PanelSDKManager.instance.getPlans();
    print('📦 可用套餐数量: ${plans.length}');
    
    for (var plan in plans.take(3)) {
      print('  - ${plan['name']}: ${plan['month_price']} 元/月');
    }
    
    // 获取订单列表
    final orders = await PanelSDKManager.instance.getOrders();
    print('📋 订单数量: ${orders.length}');
    
    for (var order in orders.take(3)) {
      print('  - 订单号: ${order['trade_no']}, 状态: ${order['status']}');
    }
  } catch (e) {
    print('❌ 获取失败: $e');
  }
}

/// 示例 5: 获取公告和邀请信息
Future<void> example5_getNoticesAndInvites() async {
  print('\n=== 示例 5: 获取公告和邀请 ===');
  
  try {
    // 获取公告列表
    final notices = await PanelSDKManager.instance.getNotices();
    print('📢 公告数量: ${notices.length}');
    
    for (var notice in notices.take(2)) {
      print('  - ${notice['title']}');
    }
    
    // 获取邀请信息
    final inviteInfo = await PanelSDKManager.instance.getInviteInfo();
    if (inviteInfo != null) {
      print('👥 邀请信息:');
      final codes = inviteInfo['codes'] as List?;
      final stats = inviteInfo['stat'] as List?;
      
      if (codes != null && codes.isNotEmpty) {
        print('  邀请码: ${codes.first['code']}');
      }
      if (stats != null && stats.isNotEmpty) {
        print('  注册人数: ${stats.first['register_count']}');
        print('  佣金余额: ${stats.first['commission_balance']}');
      }
    }
  } catch (e) {
    print('❌ 获取失败: $e');
  }
}

/// 示例 6: 切换面板类型
Future<void> example6_switchPanel() async {
  print('\n=== 示例 6: 切换面板类型 ===');
  
  try {
    // 初始化为 XBoard
    await PanelSDKManager.init(
      panelType: 'xboard',
      baseUrl: 'https://xboard-panel.com',
    );
    print('当前面板: ${PanelSDKManager.currentPanelType}');
    
    // 切换到 V2Board
    await PanelSDKManager.switchPanel(
      panelType: 'v2board',
      baseUrl: 'https://v2board-panel.com',
    );
    print('切换后面板: ${PanelSDKManager.currentPanelType}');
    
    // 现在所有 API 调用都会使用 V2Board SDK
    final userInfo = await PanelSDKManager.instance.getUserInfo();
    print('✅ 使用 V2Board 获取用户信息成功');
  } catch (e) {
    print('❌ 切换失败: $e');
  }
}

/// 示例 7: Token 管理
Future<void> example7_tokenManagement() async {
  print('\n=== 示例 7: Token 管理 ===');
  
  try {
    // 保存 Token
    await PanelSDKManager.instance.saveToken('your-auth-token');
    print('✅ Token 已保存');
    
    // 检查是否有 Token
    final hasToken = await PanelSDKManager.instance.hasToken();
    print('是否有 Token: $hasToken');
    
    // 获取 Token
    final token = await PanelSDKManager.instance.getToken();
    print('当前 Token: ${token?.substring(0, 20)}...');
    
    // 清除 Token
    await PanelSDKManager.instance.clearToken();
    print('✅ Token 已清除');
  } catch (e) {
    print('❌ Token 操作失败: $e');
  }
}

/// 示例 8: 完整的应用流程
Future<void> example8_completeWorkflow() async {
  print('\n=== 示例 8: 完整应用流程 ===');
  
  try {
    // 1. 初始化
    print('1️⃣ 初始化 SDK...');
    await PanelSDKManager.initFromConfig();
    print('   使用面板: ${PanelSDKManager.currentPanelType}');
    
    // 2. 登录
    print('2️⃣ 用户登录...');
    final loginSuccess = await PanelSDKManager.instance.login(
      email: 'user@example.com',
      password: 'password123',
    );
    
    if (!loginSuccess) {
      print('   ❌ 登录失败');
      return;
    }
    print('   ✅ 登录成功');
    
    // 3. 获取用户信息
    print('3️⃣ 获取用户信息...');
    final userInfo = await PanelSDKManager.instance.getUserInfo();
    print('   用户: ${userInfo?['email']}');
    
    // 4. 获取订阅链接
    print('4️⃣ 获取订阅链接...');
    final subUrl = await PanelSDKManager.instance.getSubscriptionUrl();
    print('   订阅: ${subUrl?.substring(0, 40)}...');
    
    // 5. 浏览套餐
    print('5️⃣ 浏览套餐...');
    final plans = await PanelSDKManager.instance.getPlans();
    print('   找到 ${plans.length} 个套餐');
    
    // 6. 查看订单
    print('6️⃣ 查看订单历史...');
    final orders = await PanelSDKManager.instance.getOrders();
    print('   历史订单: ${orders.length} 个');
    
    // 7. 登出
    print('7️⃣ 退出登录...');
    await PanelSDKManager.instance.logout();
    print('   ✅ 已登出');
    
    print('\n🎉 完整流程执行成功！');
  } catch (e) {
    print('❌ 流程出错: $e');
  }
}

/// 主函数 - 运行所有示例
Future<void> main() async {
  print('╔════════════════════════════════════════╗');
  print('║   Panel SDK 使用示例                  ║');
  print('╚════════════════════════════════════════╝\n');
  
  // 运行所有示例
  await example1_initFromConfig();
  await example2_manualInit();
  await example3_loginAndBasicOperations();
  await example4_getPlansAndOrders();
  await example5_getNoticesAndInvites();
  await example6_switchPanel();
  await example7_tokenManagement();
  await example8_completeWorkflow();
  
  // 清理资源
  PanelSDKManager.dispose();
  
  print('\n✅ 所有示例执行完成！');
}

