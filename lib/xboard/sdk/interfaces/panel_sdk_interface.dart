/// 面板 SDK 统一接口
/// 
/// 定义了 XBoard 和 V2Board 的通用功能接口
abstract class PanelSDKInterface {
  /// SDK 类型
  String get sdkType;
  
  /// 是否已初始化
  bool get isInitialized;
  
  /// 是否已认证
  bool get isAuthenticated;
  
  /// 初始化 SDK
  Future<void> initialize({
    required String baseUrl,
    Map<String, dynamic>? config,
  });
  
  /// 登录
  Future<bool> login({
    required String email,
    required String password,
  });
  
  /// 登出
  Future<void> logout();
  
  /// 保存 Token
  Future<void> saveToken(String token);
  
  /// 获取 Token
  Future<String?> getToken();
  
  /// 清除 Token
  Future<void> clearToken();
  
  /// 检查是否有 Token
  Future<bool> hasToken();
  
  /// 获取用户信息
  Future<Map<String, dynamic>?> getUserInfo();
  
  /// 获取订阅链接
  Future<String?> getSubscriptionUrl();
  
  /// 获取套餐列表
  Future<List<Map<String, dynamic>>> getPlans();
  
  /// 获取订单列表
  Future<List<Map<String, dynamic>>> getOrders();
  
  /// 获取公告列表
  Future<List<Map<String, dynamic>>> getNotices();
  
  /// 获取邀请信息
  Future<Map<String, dynamic>?> getInviteInfo();
  
  /// 释放资源
  void dispose();
}

