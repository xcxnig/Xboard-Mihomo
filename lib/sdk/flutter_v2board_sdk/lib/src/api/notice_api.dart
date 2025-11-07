import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/notice.dart';

/// 公告 API
/// 
/// 参考：app/Http/Controllers/V1/User/NoticeController.php
class NoticeApi {
  final Dio _dio;
  
  NoticeApi(this._dio);
  
  /// 获取公告列表
  /// 
  /// GET /api/v1/user/notice/fetch
  Future<ApiResponse<List<Notice>>> getNotices() async {
    try {
      final response = await _dio.get('/api/v1/user/notice/fetch');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> noticesJson = response.data['data'];
        final notices = noticesJson.map((json) => Notice.fromJson(json)).toList();
        
        return ApiResponse(
          data: notices,
          success: true,
        );
      }
      
      return ApiResponse(
        data: [],
        success: false,
        message: response.data['message'] ?? 'Failed to get notices',
      );
    } catch (e) {
      rethrow;
    }
  }
}
