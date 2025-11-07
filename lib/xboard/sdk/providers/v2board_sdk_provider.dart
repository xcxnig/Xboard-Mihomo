import '../interfaces/panel_sdk_interface.dart';
import '../../../sdk/flutter_v2board_sdk/flutter_v2board_sdk.dart';

/// V2Board SDK Provider
/// 
/// V2Board SDK 的适配器实现
class V2BoardSDKProvider implements PanelSDKInterface {
  V2BoardClient? _client;
  String? _baseUrl;
  
  @override
  String get sdkType => 'v2board';
  
  @override
  bool get isInitialized => _client != null;
  
  @override
  bool get isAuthenticated {
    // V2Board 使用异步检查，这里需要同步返回
    // 简单判断：如果 client 存在就认为可能已认证
    return _client != null;
  }
  
  @override
  Future<void> initialize({
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    _baseUrl = baseUrl;
    
    // 创建 V2Board 客户端
    _client = V2BoardClient(
      baseUrl: baseUrl,
      timeout: config?['timeout'] as Duration?,
    );
  }
  
  @override
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (_client == null) {
      throw Exception('SDK not initialized. Call initialize() first.');
    }
    
    try {
      final response = await _client!.auth.login(
        email: email,
        password: password,
      );
      
      if (response.success && response.data != null) {
        // V2Board 返回的 token 已经包含在响应中
        return true;
      }
      return false;
    } catch (e) {
      print('[V2BoardSDKProvider] Login failed: $e');
      return false;
    }
  }
  
  @override
  Future<void> logout() async {
    if (_client == null) return;
    await _client!.clearToken();
  }
  
  @override
  Future<void> saveToken(String token) async {
    // V2Board 的 token 在登录时自动保存
    // 这里提供手动保存接口
    if (_client == null) {
      throw Exception('SDK not initialized. Call initialize() first.');
    }
    // V2Board SDK 通过 TokenStorage 自动管理
    // 这里不需要额外操作
  }
  
  @override
  Future<String?> getToken() async {
    if (_client == null) return null;
    return await _client!.getToken();
  }
  
  @override
  Future<void> clearToken() async {
    if (_client == null) return;
    await _client!.clearToken();
  }
  
  @override
  Future<bool> hasToken() async {
    if (_client == null) return false;
    final token = await _client!.getToken();
    return token != null && token.isNotEmpty;
  }
  
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    if (_client == null) return null;
    
    try {
      final response = await _client!.user.getUserInfo();
      if (response.success && response.data != null) {
        return response.data!.toJson();
      }
      return null;
    } catch (e) {
      print('[V2BoardSDKProvider] Failed to get user info: $e');
      return null;
    }
  }
  
  @override
  Future<String?> getSubscriptionUrl() async {
    if (_client == null) return null;
    
    try {
      final response = await _client!.user.getSubscription();
      if (response.success && response.data != null) {
        return response.data!.subscribeUrl;
      }
      return null;
    } catch (e) {
      print('[V2BoardSDKProvider] Failed to get subscription URL: $e');
      return null;
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getPlans() async {
    if (_client == null) return [];
    
    try {
      final response = await _client!.plan.getPlans();
      if (response.success && response.data != null) {
        return response.data!.map((plan) => plan.toJson()).toList();
      }
      return [];
    } catch (e) {
      print('[V2BoardSDKProvider] Failed to get plans: $e');
      return [];
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getOrders() async {
    if (_client == null) return [];
    
    try {
      final response = await _client!.order.getOrders();
      if (response.success && response.data != null) {
        return response.data!.map((order) => order.toJson()).toList();
      }
      return [];
    } catch (e) {
      print('[V2BoardSDKProvider] Failed to get orders: $e');
      return [];
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getNotices() async {
    if (_client == null) return [];
    
    try {
      final response = await _client!.notice.getNotices();
      if (response.success && response.data != null) {
        return response.data!.map((notice) => notice.toJson()).toList();
      }
      return [];
    } catch (e) {
      print('[V2BoardSDKProvider] Failed to get notices: $e');
      return [];
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getInviteInfo() async {
    if (_client == null) return null;
    
    try {
      final response = await _client!.invite.getInviteInfo();
      if (response.success && response.data != null) {
        // 转换 InviteInfo 为 Map
        final inviteInfo = response.data!;
        return {
          'codes': inviteInfo.codes?.map((code) => code.toJson()).toList(),
          'stat': inviteInfo.stat?.map((stat) => stat.toJson()).toList(),
        };
      }
      return null;
    } catch (e) {
      print('[V2BoardSDKProvider] Failed to get invite info: $e');
      return null;
    }
  }
  
  @override
  void dispose() {
    _client?.dispose();
    _client = null;
  }
}

