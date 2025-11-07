import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/order.dart';
import '../models/payment_method.dart';

/// 订单 API
/// 
/// 参考：app/Http/Controllers/V1/User/OrderController.php
class OrderApi {
  final Dio _dio;
  
  OrderApi(this._dio);
  
  /// 创建订单
  /// 
  /// POST /api/v1/user/order/save
  Future<ApiResponse<String>> createOrder({
    required int planId,
    required String period,
    String? couponCode,
  }) async {
    try {
      final response = await _dio.post('/api/v1/user/order/save', data: {
        'plan_id': planId,
        'period': period,
        if (couponCode != null) 'coupon_code': couponCode,
      });
      
      return ApiResponse(
        data: response.data['data'] as String?,
        success: response.data['data'] != null,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 提交订单支付
  /// 
  /// POST /api/v1/user/order/checkout
  Future<ApiResponse<Map<String, dynamic>>> checkout({
    required String tradeNo,
    required int method,
  }) async {
    try {
      final response = await _dio.post('/api/v1/user/order/checkout', data: {
        'trade_no': tradeNo,
        'method': method,
      });
      
      return ApiResponse(
        data: response.data['data'] as Map<String, dynamic>?,
        success: true,
        message: response.data['message'],
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 检查订单状态
  /// 
  /// GET /api/v1/user/order/check?trade_no={tradeNo}
  Future<ApiResponse<int>> checkOrder(String tradeNo) async {
    try {
      final response = await _dio.get('/api/v1/user/order/check', queryParameters: {
        'trade_no': tradeNo,
      });
      
      return ApiResponse(
        data: response.data['data'] as int?,
        success: true,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取订单详情
  /// 
  /// GET /api/v1/user/order/detail?trade_no={tradeNo}
  Future<ApiResponse<Order>> getOrderDetail(String tradeNo) async {
    try {
      final response = await _dio.get('/api/v1/user/order/detail', queryParameters: {
        'trade_no': tradeNo,
      });
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final order = Order.fromJson(response.data['data']);
        return ApiResponse(
          data: order,
          success: true,
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.data['message'] ?? 'Failed to get order detail',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取订单列表
  /// 
  /// GET /api/v1/user/order/fetch
  Future<ApiResponse<List<Order>>> getOrders() async {
    try {
      final response = await _dio.get('/api/v1/user/order/fetch');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> ordersJson = response.data['data'];
        final orders = ordersJson.map((json) => Order.fromJson(json)).toList();
        
        return ApiResponse(
          data: orders,
          success: true,
        );
      }
      
      return ApiResponse(
        data: [],
        success: false,
        message: response.data['message'] ?? 'Failed to get orders',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 获取支付方式列表
  /// 
  /// GET /api/v1/user/order/getPaymentMethod
  Future<ApiResponse<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final response = await _dio.get('/api/v1/user/order/getPaymentMethod');
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> methodsJson = response.data['data'];
        final methods = methodsJson.map((json) => PaymentMethod.fromJson(json)).toList();
        
        return ApiResponse(
          data: methods,
          success: true,
        );
      }
      
      return ApiResponse(
        data: [],
        success: false,
        message: response.data['message'] ?? 'Failed to get payment methods',
      );
    } catch (e) {
      rethrow;
    }
  }
  
  /// 取消订单
  /// 
  /// POST /api/v1/user/order/cancel
  Future<ApiResponse<bool>> cancelOrder(String tradeNo) async {
    try {
      final response = await _dio.post('/api/v1/user/order/cancel', data: {
        'trade_no': tradeNo,
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
}
