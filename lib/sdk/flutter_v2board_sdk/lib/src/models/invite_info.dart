/// 邀请信息数据模型
class InviteInfo {
  final List<InviteCode>? codes;
  final List<InviteStat>? stat;
  
  InviteInfo({
    this.codes,
    this.stat,
  });
  
  factory InviteInfo.fromJson(Map<String, dynamic> json) {
    List<InviteCode>? codes;
    if (json['codes'] != null) {
      codes = (json['codes'] as List)
          .map((item) => InviteCode.fromJson(item))
          .toList();
    }
    
    List<InviteStat>? stat;
    if (json['stat'] != null) {
      stat = (json['stat'] as List)
          .map((item) => InviteStat.fromJson(item))
          .toList();
    }
    
    return InviteInfo(
      codes: codes,
      stat: stat,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'codes': codes?.map((code) => code.toJson()).toList(),
      'stat': stat?.map((s) => s.toJson()).toList(),
    };
  }
}

/// 邀请码数据模型
class InviteCode {
  final int? id;
  final int? userId;
  final String? code;
  final int? status;
  final int? createdAt;
  final int? updatedAt;
  
  InviteCode({
    this.id,
    this.userId,
    this.code,
    this.status,
    this.createdAt,
    this.updatedAt,
  });
  
  factory InviteCode.fromJson(Map<String, dynamic> json) {
    return InviteCode(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      code: json['code'] as String?,
      status: json['status'] as int?,
      createdAt: json['created_at'] as int?,
      updatedAt: json['updated_at'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  /// 是否可用
  bool get isAvailable => status == 0;
}

/// 邀请统计数据模型
class InviteStat {
  final int? registerCount;
  final int? commissionRate;
  final int? commissionBalance;
  final int? commissionPendingBalance;
  
  InviteStat({
    this.registerCount,
    this.commissionRate,
    this.commissionBalance,
    this.commissionPendingBalance,
  });
  
  factory InviteStat.fromJson(Map<String, dynamic> json) {
    return InviteStat(
      registerCount: json['register_count'] as int?,
      commissionRate: json['commission_rate'] as int?,
      commissionBalance: json['commission_balance'] as int?,
      commissionPendingBalance: json['commission_pending_balance'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'register_count': registerCount,
      'commission_rate': commissionRate,
      'commission_balance': commissionBalance,
      'commission_pending_balance': commissionPendingBalance,
    };
  }
}
