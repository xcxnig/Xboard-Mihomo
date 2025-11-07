import '../interfaces/panel_sdk_interface.dart';
import '../../../sdk/flutter_xboard_sdk/flutter_xboard_sdk.dart';

/// XBoard SDK Provider
/// 
/// XBoard SDK 的适配器实现
class XBoardSDKProvider implements PanelSDKInterface {
  XBoardSDK? _sdk;
  
  @override
  String get sdkType => 'xboard';
  
  @override
  bool get isInitialized => _sdk?.isInitialized ?? false;
  
  @override
  bool get isAuthenticated => _sdk?.isAuthenticated ?? false;
  
  @override
  Future<void> initialize({
    required String baseUrl,
    Map<String, dynamic>? config,
  }) async {
    _sdk = XBoardSDK.instance;
    
    // 构建 HTTP 配置
    HttpConfig? httpConfig;
    if (config != null) {
      httpConfig = HttpConfig(
        userAgent: config['userAgent'] as String? ?? 'FlClash-XBoard-SDK/1.0',
        obfuscationPrefix: config['obfuscationPrefix'] as String?,
        allowBadCertificates: config['allowBadCertificates'] as bool? ?? false,
      );
    }
    
    await _sdk!.initialize(
      baseUrl,
      httpConfig: httpConfig,
      useMemoryStorage: config?['useMemoryStorage'] as bool? ?? false,
    );
  }
  
  @override
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    if (_sdk == null) {
      throw Exception('SDK not initialized. Call initialize() first.');
    }
    
    return await _sdk!.loginWithCredentials(email, password);
  }
  
  @override
  Future<void> logout() async {
    if (_sdk == null) return;
    await _sdk!.logout();
  }
  
  @override
  Future<void> saveToken(String token) async {
    if (_sdk == null) {
      throw Exception('SDK not initialized. Call initialize() first.');
    }
    await _sdk!.saveToken(token);
  }
  
  @override
  Future<String?> getToken() async {
    if (_sdk == null) return null;
    return await _sdk!.getToken();
  }
  
  @override
  Future<void> clearToken() async {
    if (_sdk == null) return;
    await _sdk!.clearToken();
  }
  
  @override
  Future<bool> hasToken() async {
    if (_sdk == null) return false;
    return await _sdk!.hasToken();
  }
  
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    if (_sdk == null) return null;
    
    try {
      final response = await _sdk!.userInfo.getUserInfo();
      if (response.success == true && response.data != null) {
        return response.data!.toJson();
      }
      return null;
    } catch (e) {
      print('[XBoardSDKProvider] Failed to get user info: $e');
      return null;
    }
  }
  
  @override
  Future<String?> getSubscriptionUrl() async {
    if (_sdk == null) return null;
    
    try {
      final response = await _sdk!.subscription.getUserSubscription();
      if (response.success == true && response.data != null) {
        return response.data!.subscribeUrl;
      }
      return null;
    } catch (e) {
      print('[XBoardSDKProvider] Failed to get subscription URL: $e');
      return null;
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getPlans() async {
    if (_sdk == null) return [];
    
    try {
      final response = await _sdk!.plan.fetchPlans();
      if (response.success == true && response.data != null) {
        return response.data!.map((plan) => plan.toJson()).toList();
      }
      return [];
    } catch (e) {
      print('[XBoardSDKProvider] Failed to get plans: $e');
      return [];
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getOrders() async {
    if (_sdk == null) return [];
    
    try {
      final response = await _sdk!.order.getOrders();
      if (response.success == true && response.data != null) {
        return response.data!.map((order) => order.toJson()).toList();
      }
      return [];
    } catch (e) {
      print('[XBoardSDKProvider] Failed to get orders: $e');
      return [];
    }
  }
  
  @override
  Future<List<Map<String, dynamic>>> getNotices() async {
    if (_sdk == null) return [];
    
    try {
      final response = await _sdk!.notice.getNotices();
      if (response.success == true && response.data != null) {
        return response.data!.map((notice) => notice.toJson()).toList();
      }
      return [];
    } catch (e) {
      print('[XBoardSDKProvider] Failed to get notices: $e');
      return [];
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getInviteInfo() async {
    if (_sdk == null) return null;
    
    try {
      final response = await _sdk!.invite.getInviteInfo();
      if (response.success == true && response.data != null) {
        return response.data!.toJson();
      }
      return null;
    } catch (e) {
      print('[XBoardSDKProvider] Failed to get invite info: $e');
      return null;
    }
  }
  
  @override
  void dispose() {
    _sdk?.dispose();
    _sdk = null;
  }
}

