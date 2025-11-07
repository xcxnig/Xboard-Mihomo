import 'package:dio/dio.dart';
import 'api/auth_api.dart';
import 'api/user_api.dart';
import 'api/plan_api.dart';
import 'api/order_api.dart';
import 'api/invite_api.dart';
import 'api/coupon_api.dart';
import 'api/notice_api.dart';
import 'utils/token_storage.dart';

/// V2Board SDK 客户端
/// 
/// 这是 V2Board API 的完整封装
class V2BoardClient {
  final Dio _dio;
  final String baseUrl;
  final TokenStorage _tokenStorage;
  
  // API 模块
  late final AuthApi auth;
  late final UserApi user;
  late final PlanApi plan;
  late final OrderApi order;
  late final InviteApi invite;
  late final CouponApi coupon;
  late final NoticeApi notice;
  
  V2BoardClient({
    required this.baseUrl,
    TokenStorage? tokenStorage,
    Duration? timeout,
  })  : _tokenStorage = tokenStorage ?? TokenStorage(),
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: timeout ?? const Duration(seconds: 30),
          receiveTimeout: timeout ?? const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )) {
    // 初始化 API 模块
    auth = AuthApi(_dio, _tokenStorage);
    user = UserApi(_dio);
    plan = PlanApi(_dio);
    order = OrderApi(_dio);
    invite = InviteApi(_dio);
    coupon = CouponApi(_dio);
    notice = NoticeApi(_dio);
    
    // 添加拦截器
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // 请求拦截器 - 添加 Token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 添加认证 token
        final token = await _tokenStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // 统一响应处理
        return handler.next(response);
      },
      onError: (error, handler) {
        // 统一错误处理
        if (error.response?.statusCode == 401) {
          // Token 过期，清除本地 token
          _tokenStorage.clearToken();
        }
        return handler.next(error);
      },
    ));
  }
  
  /// 检查是否已认证
  Future<bool> get isAuthenticated async {
    final token = await _tokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }
  
  /// 获取当前 Token
  Future<String?> getToken() => _tokenStorage.getToken();
  
  /// 清除 Token
  Future<void> clearToken() => _tokenStorage.clearToken();
  
  /// 释放资源
  void dispose() {
    _dio.close();
  }
}

