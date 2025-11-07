import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/coupon.dart';

/// 优惠券 API
/// 
/// 参考：app/Http/Controllers/V1/User/CouponController.php
class CouponApi {
  final Dio _dio;
  
  CouponApi(this._dio);
  
  /// 验证优惠券
  /// 
  /// POST /api/v1/user/coupon/check
  Future<ApiResponse<Coupon>> checkCoupon({
    required String code,
    required int planId,
  }) async {
    try {
      final response = await _dio.post('/api/v1/user/coupon/check', data: {
        'code': code,
        'plan_id': planId,
      });
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final coupon = Coupon.fromJson(response.data['data']);
        return ApiResponse(
          data: coupon,
          success: true,
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Invalid coupon',
      );
    } catch (e) {
      rethrow;
    }
  }
}
