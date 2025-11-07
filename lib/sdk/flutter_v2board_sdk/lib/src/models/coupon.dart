/// 优惠券数据模型
class Coupon {
  final int? id;
  final String? code;
  final String? name;
  final int? type;
  final int? value;
  final int? limitUse;
  final int? limitUseWithUser;
  final List<int>? limitPlanIds;
  final int? startedAt;
  final int? endedAt;
  final int? createdAt;
  final int? updatedAt;
  
  Coupon({
    this.id,
    this.code,
    this.name,
    this.type,
    this.value,
    this.limitUse,
    this.limitUseWithUser,
    this.limitPlanIds,
    this.startedAt,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Coupon.fromJson(Map<String, dynamic> json) {
    List<int>? planIds;
    if (json['limit_plan_ids'] != null) {
      if (json['limit_plan_ids'] is List) {
        planIds = (json['limit_plan_ids'] as List).cast<int>();
      }
    }
    
    return Coupon(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      type: json['type'] as int?,
      value: json['value'] as int?,
      limitUse: json['limit_use'] as int?,
      limitUseWithUser: json['limit_use_with_user'] as int?,
      limitPlanIds: planIds,
      startedAt: json['started_at'] as int?,
      endedAt: json['ended_at'] as int?,
      createdAt: json['created_at'] as int?,
      updatedAt: json['updated_at'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'type': type,
      'value': value,
      'limit_use': limitUse,
      'limit_use_with_user': limitUseWithUser,
      'limit_plan_ids': limitPlanIds,
      'started_at': startedAt,
      'ended_at': endedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  /// 优惠券类型：1=金额，2=百分比
  bool get isAmountType => type == 1;
  bool get isPercentType => type == 2;
  
  /// 计算折扣金额
  int calculateDiscount(int originalAmount) {
    if (type == 1) {
      // 固定金额
      return value ?? 0;
    } else if (type == 2) {
      // 百分比
      return (originalAmount * (value ?? 0) / 100).round();
    }
    return 0;
  }
}
