/// 订单数据模型
class Order {
  final int? id;
  final String? tradeNo;
  final int? userId;
  final int? planId;
  final int? couponId;
  final int? paymentId;
  final int? type;
  final String? period;
  final int? totalAmount;
  final int? status;
  final int? commissionStatus;
  final int? commissionBalance;
  final int? actualCommissionBalance;
  final int? surplusAmount;
  final int? refundAmount;
  final int? balanceAmount;
  final int? surplusOrderIds;
  final int? createdAt;
  final int? updatedAt;
  
  /// 套餐信息（关联）
  final Map<String, dynamic>? plan;
  
  Order({
    this.id,
    this.tradeNo,
    this.userId,
    this.planId,
    this.couponId,
    this.paymentId,
    this.type,
    this.period,
    this.totalAmount,
    this.status,
    this.commissionStatus,
    this.commissionBalance,
    this.actualCommissionBalance,
    this.surplusAmount,
    this.refundAmount,
    this.balanceAmount,
    this.surplusOrderIds,
    this.createdAt,
    this.updatedAt,
    this.plan,
  });
  
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int?,
      tradeNo: json['trade_no'] as String?,
      userId: json['user_id'] as int?,
      planId: json['plan_id'] as int?,
      couponId: json['coupon_id'] as int?,
      paymentId: json['payment_id'] as int?,
      type: json['type'] as int?,
      period: json['period'] as String?,
      totalAmount: json['total_amount'] as int?,
      status: json['status'] as int?,
      commissionStatus: json['commission_status'] as int?,
      commissionBalance: json['commission_balance'] as int?,
      actualCommissionBalance: json['actual_commission_balance'] as int?,
      surplusAmount: json['surplus_amount'] as int?,
      refundAmount: json['refund_amount'] as int?,
      balanceAmount: json['balance_amount'] as int?,
      surplusOrderIds: json['surplus_order_ids'] as int?,
      createdAt: json['created_at'] as int?,
      updatedAt: json['updated_at'] as int?,
      plan: json['plan'] as Map<String, dynamic>?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trade_no': tradeNo,
      'user_id': userId,
      'plan_id': planId,
      'coupon_id': couponId,
      'payment_id': paymentId,
      'type': type,
      'period': period,
      'total_amount': totalAmount,
      'status': status,
      'commission_status': commissionStatus,
      'commission_balance': commissionBalance,
      'actual_commission_balance': actualCommissionBalance,
      'surplus_amount': surplusAmount,
      'refund_amount': refundAmount,
      'balance_amount': balanceAmount,
      'surplus_order_ids': surplusOrderIds,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'plan': plan,
    };
  }
  
  /// 订单状态：0=待支付，1=开通中，2=已取消，3=已完成，4=已折抵
  bool get isPending => status == 0;
  bool get isProcessing => status == 1;
  bool get isCancelled => status == 2;
  bool get isCompleted => status == 3;
  bool get isDiscounted => status == 4;
}
