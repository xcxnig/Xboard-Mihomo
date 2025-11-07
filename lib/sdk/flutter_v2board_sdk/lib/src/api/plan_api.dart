import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/plan.dart';

/// 套餐 API
/// 
/// 参考：app/Http/Controllers/V1/User/PlanController.php
class PlanApi {
  final Dio _dio;
  
  PlanApi(this._dio);
  
  /// 获取套餐列表
  /// 
  /// GET /api/v1/user/plan/fetch
  Future<ApiResponse<List<Plan>>> getPlans() async {
    try {
      final response = await _dio.get('/api/v1/user/plan/fetch');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> plansJson = response.data['data'];
        final plans = plansJson.map((json) => Plan.fromJson(json)).toList();
        
        return ApiResponse(
          data: plans,
          success: true,
        );
      }
      
      return ApiResponse(
        data: [],
        success: false,
        message: response.data['message'] ?? 'Failed to get plans',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取单个套餐详情
  /// 
  /// GET /api/v1/user/plan/fetch?id={planId}
  Future<ApiResponse<Plan>> getPlan(int planId) async {
    try {
      final response = await _dio.get('/api/v1/user/plan/fetch', queryParameters: {
        'id': planId,
      });
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final plan = Plan.fromJson(response.data['data']);
        return ApiResponse(
          data: plan,
          success: true,
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to get plan',
      );
    } catch (e) {
      rethrow;
    }
  }
}
