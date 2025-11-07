/// 用户信息数据模型
class UserInfo {
  final String email;
  final int? transferEnable;
  final int? deviceLimit;
  final int? lastLoginAt;
  final int? createdAt;
  final int? banned;
  final int? autoRenewal;
  final int? remindExpire;
  final int? remindTraffic;
  final int? expiredAt;
  final int? balance;
  final int? commissionBalance;
  final int? planId;
  final int? discount;
  final int? commissionRate;
  final int? telegramId;
  final String? uuid;
  final String? avatarUrl;
  
  /// 已上传流量 (bytes)
  final int? u;
  
  /// 已下载流量 (bytes)
  final int? d;
  
  UserInfo({
    required this.email,
    this.transferEnable,
    this.deviceLimit,
    this.lastLoginAt,
    this.createdAt,
    this.banned,
    this.autoRenewal,
    this.remindExpire,
    this.remindTraffic,
    this.expiredAt,
    this.balance,
    this.commissionBalance,
    this.planId,
    this.discount,
    this.commissionRate,
    this.telegramId,
    this.uuid,
    this.avatarUrl,
    this.u,
    this.d,
  });
  
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'] as String,
      transferEnable: json['transfer_enable'] as int?,
      deviceLimit: json['device_limit'] as int?,
      lastLoginAt: json['last_login_at'] as int?,
      createdAt: json['created_at'] as int?,
      banned: json['banned'] as int?,
      autoRenewal: json['auto_renewal'] as int?,
      remindExpire: json['remind_expire'] as int?,
      remindTraffic: json['remind_traffic'] as int?,
      expiredAt: json['expired_at'] as int?,
      balance: json['balance'] as int?,
      commissionBalance: json['commission_balance'] as int?,
      planId: json['plan_id'] as int?,
      discount: json['discount'] as int?,
      commissionRate: json['commission_rate'] as int?,
      telegramId: json['telegram_id'] as int?,
      uuid: json['uuid'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      u: json['u'] as int?,
      d: json['d'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'transfer_enable': transferEnable,
      'device_limit': deviceLimit,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'banned': banned,
      'auto_renewal': autoRenewal,
      'remind_expire': remindExpire,
      'remind_traffic': remindTraffic,
      'expired_at': expiredAt,
      'balance': balance,
      'commission_balance': commissionBalance,
      'plan_id': planId,
      'discount': discount,
      'commission_rate': commissionRate,
      'telegram_id': telegramId,
      'uuid': uuid,
      'avatar_url': avatarUrl,
      'u': u,
      'd': d,
    };
  }
  
  /// 是否已过期
  bool get isExpired {
    if (expiredAt == null) return false;
    return expiredAt! * 1000 < DateTime.now().millisecondsSinceEpoch;
  }
  
  /// 是否被封禁
  bool get isBanned => banned == 1;
  
  /// 已使用流量 (bytes)
  int get usedTraffic => (u ?? 0) + (d ?? 0);
  
  /// 剩余流量 (bytes)
  int get remainingTraffic {
    final total = transferEnable ?? 0;
    final used = usedTraffic;
    return (total - used).clamp(0, total);
  }
  
  /// 流量使用百分比 (0-100)
  double get trafficUsagePercent {
    final total = transferEnable ?? 0;
    if (total == 0) return 0;
    return (usedTraffic / total * 100).clamp(0, 100);
  }
}
