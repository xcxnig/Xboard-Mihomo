import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/invite_info.dart';

/// 邀请 API
/// 
/// 参考：app/Http/Controllers/V1/User/InviteController.php
class InviteApi {
  final Dio _dio;
  
  InviteApi(this._dio);
  
  /// 获取邀请信息
  /// 
  /// GET /api/v1/user/invite/fetch
  Future<ApiResponse<InviteInfo>> getInviteInfo() async {
    try {
      final response = await _dio.get('/api/v1/user/invite/fetch');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final inviteInfo = InviteInfo.fromJson(response.data['data']);
        return ApiResponse(
          data: inviteInfo,
          success: true,
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to get invite info',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 生成邀请码
  /// 
  /// GET /api/v1/user/invite/save
  Future<ApiResponse<bool>> generateInviteCode() async {
    try {
      final response = await _dio.get('/api/v1/user/invite/save');
      
      return ApiResponse(
        data: response.data['data'] == true,
        success: response.data['data'] == true,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取邀请详情
  /// 
  /// GET /api/v1/user/invite/details
  Future<ApiResponse<List<Map<String, dynamic>>>> getInviteDetails() async {
    try {
      final response = await _dio.get('/api/v1/user/invite/details');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> details = response.data['data'];
        final detailsList = details.cast<Map<String, dynamic>>();
        
        return ApiResponse(
          data: detailsList,
          success: true,
        );
      }
      
      return ApiResponse(
        data: [],
        success: false,
        message: response.data['message'] ?? 'Failed to get invite details',
      );
    } catch (e) {
      rethrow;
    }
  }
}
