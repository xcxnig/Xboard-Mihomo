import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/user_info.dart';
import '../models/subscription_info.dart';

/// 用户 API
/// 
/// 参考：app/Http/Controllers/V1/User/UserController.php
class UserApi {
  final Dio _dio;
  
  UserApi(this._dio);
  
  /// 获取用户信息
  /// 
  /// GET /api/v1/user/info
  Future<ApiResponse<UserInfo>> getUserInfo() async {
    try {
      final response = await _dio.get('/api/v1/user/info');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final userInfo = UserInfo.fromJson(response.data['data']);
        return ApiResponse(
          data: userInfo,
          success: true,
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to get user info',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取订阅链接
  /// 
  /// GET /api/v1/user/getSubscribe
  Future<ApiResponse<SubscriptionInfo>> getSubscription() async {
    try {
      final response = await _dio.get('/api/v1/user/getSubscribe');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final subscriptionInfo = SubscriptionInfo.fromJson(response.data['data']);
        return ApiResponse(
          data: subscriptionInfo,
          success: true,
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to get subscription',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 更新用户信息
  /// 
  /// POST /api/v1/user/update
  Future<ApiResponse<bool>> updateUser({
    bool? remindExpire,
    bool? remindTraffic,
    bool? autoRenewal,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (remindExpire != null) data['remind_expire'] = remindExpire ? 1 : 0;
      if (remindTraffic != null) data['remind_traffic'] = remindTraffic ? 1 : 0;
      if (autoRenewal != null) data['auto_renewal'] = autoRenewal ? 1 : 0;
      
      final response = await _dio.post('/api/v1/user/update', data: data);
      
      return ApiResponse(
        data: response.data['data'] == true,
        success: response.data['data'] == true,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 修改密码
  /// 
  /// POST /api/v1/user/changePassword
  Future<ApiResponse<bool>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post('/api/v1/user/changePassword', data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
      
      return ApiResponse(
        data: response.data['data'] == true,
        success: response.data['data'] == true,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 解绑 Telegram
  /// 
  /// GET /api/v1/user/unbindTelegram
  Future<ApiResponse<bool>> unbindTelegram() async {
    try {
      final response = await _dio.get('/api/v1/user/unbindTelegram');
      
      return ApiResponse(
        data: response.data['data'] == true,
        success: response.data['data'] == true,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 重置安全设置
  /// 
  /// GET /api/v1/user/resetSecurity
  Future<ApiResponse<String>> resetSecurity() async {
    try {
      final response = await _dio.get('/api/v1/user/resetSecurity');
      
      return ApiResponse(
        data: response.data['data'] as String?,
        success: response.data['data'] != null,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 佣金划转到余额
  /// 
  /// POST /api/v1/user/transfer
  Future<ApiResponse<bool>> transferCommission({
    required int transferAmount,
  }) async {
    try {
      final response = await _dio.post('/api/v1/user/transfer', data: {
        'transfer_amount': transferAmount,
      });
      
      return ApiResponse(
        data: response.data['data'] == true,
        success: response.data['data'] == true,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 检查登录状态
  /// 
  /// GET /api/v1/user/checkLogin
  Future<ApiResponse<Map<String, dynamic>>> checkLogin() async {
    try {
      final response = await _dio.get('/api/v1/user/checkLogin');
      
      return ApiResponse(
        data: response.data['data'] as Map<String, dynamic>?,
        success: true,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取用户统计信息
  /// 
  /// GET /api/v1/user/getStat
  Future<ApiResponse<Map<String, dynamic>>> getUserStat() async {
    try {
      final response = await _dio.get('/api/v1/user/getStat');
      
      return ApiResponse(
        data: response.data['data'] as Map<String, dynamic>?,
        success: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}
