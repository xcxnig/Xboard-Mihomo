import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../utils/token_storage.dart';

/// 认证 API
class AuthApi {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  
  AuthApi(this._dio, this._tokenStorage);
  
  /// 登录
  /// 
  /// [email] 邮箱
  /// [password] 密码
  /// 
  /// Returns: 登录成功返回 true
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/api/v1/passport/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data['auth_data'] != null) {
          // 保存 token
          await _tokenStorage.saveToken(data['auth_data']);
          return true;
        }
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
  
  /// 注册
  /// 
  /// [email] 邮箱
  /// [password] 密码
  /// [inviteCode] 邀请码（可选）
  /// [emailCode] 邮箱验证码（可选）
  Future<ApiResponse<dynamic>> register({
    required String email,
    required String password,
    String? inviteCode,
    String? emailCode,
  }) async {
    try {
      final response = await _dio.post('/api/v1/passport/auth/register', data: {
        'email': email,
        'password': password,
        if (inviteCode != null) 'invite_code': inviteCode,
        if (emailCode != null) 'email_code': emailCode,
      });
      
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  
  /// 忘记密码
  /// 
  /// [email] 邮箱
  /// [password] 新密码
  /// [emailCode] 邮箱验证码
  Future<ApiResponse<bool>> forget({
    required String email,
    required String password,
    required String emailCode,
  }) async {
    try {
      final response = await _dio.post('/api/v1/passport/auth/forget', data: {
        'email': email,
        'password': password,
        'email_code': emailCode,
      });
      
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  
  /// 发送邮箱验证码
  /// 
  /// [email] 邮箱
  Future<ApiResponse<bool>> sendEmailVerify(String email) async {
    try {
      final response = await _dio.post('/api/v1/passport/comm/sendEmailVerify', data: {
        'email': email,
      });
      
      return ApiResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

