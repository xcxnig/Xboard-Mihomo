import 'interfaces/panel_sdk_interface.dart';
import 'panel_sdk_factory.dart';

/// 面板 SDK 管理器
/// 
/// 提供全局单例访问，简化 SDK 调用
/// 
/// 使用示例：
/// ```dart
/// // 1. 从配置初始化
/// await PanelSDKManager.initFromConfig();
/// 
/// // 2. 登录
/// final success = await PanelSDKManager.instance.login(
///   email: 'user@example.com',
///   password: 'password',
/// );
/// 
/// // 3. 获取用户信息
/// final userInfo = await PanelSDKManager.instance.getUserInfo();
/// 
/// // 4. 检查当前使用的面板类型
/// print('Current panel: ${PanelSDKManager.currentPanelType}');
/// ```
class PanelSDKManager {
  /// 获取当前 SDK 实例
  static PanelSDKInterface get instance {
    final provider = PanelSDKFactory.currentProvider;
    if (provider == null) {
      throw Exception(
        'PanelSDKManager not initialized. '
        'Call PanelSDKManager.initFromConfig() or PanelSDKManager.init() first.'
      );
    }
    return provider;
  }
  
  /// 获取当前面板类型
  static String? get currentPanelType => PanelSDKFactory.currentPanelType;
  
  /// 检查是否已初始化
  static bool get isInitialized => PanelSDKFactory.isInitialized;
  
  /// 检查是否已认证
  static bool get isAuthenticated => PanelSDKFactory.isAuthenticated;
  
  /// 从配置文件初始化 SDK
  /// 
  /// 自动读取 xboard.config.yaml 中的 panel_type 和 baseUrl
  static Future<void> initFromConfig() async {
    await PanelSDKFactory.createFromConfig();
  }
  
  /// 手动初始化 SDK
  /// 
  /// [panelType] 面板类型：'xboard' 或 'v2board'
  /// [baseUrl] 面板 API 地址
  /// [config] 可选的 SDK 配置
  static Future<void> init({
    required String panelType,
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    await PanelSDKFactory.createProvider(
      panelType: panelType,
      baseUrl: baseUrl,
      config: config,
    );
  }
  
  /// 切换到不同的面板
  /// 
  /// 销毁当前 SDK 并创建新的
  static Future<void> switchPanel({
    required String panelType,
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    await PanelSDKFactory.switchPanel(
      panelType: panelType,
      baseUrl: baseUrl,
      config: config,
    );
  }
  
  /// 释放 SDK 资源
  static void dispose() {
    PanelSDKFactory.dispose();
  }
}

/// 便捷扩展方法
extension PanelSDKManagerExtension on PanelSDKManager {
  /// 快速登录
  static Future<bool> quickLogin({
    required String email,
    required String password,
  }) async {
    return await PanelSDKManager.instance.login(
      email: email,
      password: password,
    );
  }
  
  /// 快速登出
  static Future<void> quickLogout() async {
    await PanelSDKManager.instance.logout();
  }
  
  /// 快速获取用户信息
  static Future<Map<String, dynamic>?> quickGetUserInfo() async {
    return await PanelSDKManager.instance.getUserInfo();
  }
  
  /// 快速获取订阅链接
  static Future<String?> quickGetSubscriptionUrl() async {
    return await PanelSDKManager.instance.getSubscriptionUrl();
  }
}

