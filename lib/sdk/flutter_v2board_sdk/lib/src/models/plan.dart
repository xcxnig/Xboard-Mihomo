/// 套餐计划数据模型
class Plan {
  final int id;
  final int? groupId;
  final int? transferEnable;
  final String? name;
  final int? show;
  final int? sort;
  final int? renew;
  final String? content;
  final int? monthPrice;
  final int? quarterPrice;
  final int? halfYearPrice;
  final int? yearPrice;
  final int? twoYearPrice;
  final int? threeYearPrice;
  final int? onetimePrice;
  final int? resetPrice;
  final int? resetTrafficMethod;
  final int? capacityLimit;
  final int? speedLimit;
  final int? deviceLimit;
  
  Plan({
    required this.id,
    this.groupId,
    this.transferEnable,
    this.name,
    this.show,
    this.sort,
    this.renew,
    this.content,
    this.monthPrice,
    this.quarterPrice,
    this.halfYearPrice,
    this.yearPrice,
    this.twoYearPrice,
    this.threeYearPrice,
    this.onetimePrice,
    this.resetPrice,
    this.resetTrafficMethod,
    this.capacityLimit,
    this.speedLimit,
    this.deviceLimit,
  });
  
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'] as int,
      groupId: json['group_id'] as int?,
      transferEnable: json['transfer_enable'] as int?,
      name: json['name'] as String?,
      show: json['show'] as int?,
      sort: json['sort'] as int?,
      renew: json['renew'] as int?,
      content: json['content'] as String?,
      monthPrice: json['month_price'] as int?,
      quarterPrice: json['quarter_price'] as int?,
      halfYearPrice: json['half_year_price'] as int?,
      yearPrice: json['year_price'] as int?,
      twoYearPrice: json['two_year_price'] as int?,
      threeYearPrice: json['three_year_price'] as int?,
      onetimePrice: json['onetime_price'] as int?,
      resetPrice: json['reset_price'] as int?,
      resetTrafficMethod: json['reset_traffic_method'] as int?,
      capacityLimit: json['capacity_limit'] as int?,
      speedLimit: json['speed_limit'] as int?,
      deviceLimit: json['device_limit'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'transfer_enable': transferEnable,
      'name': name,
      'show': show,
      'sort': sort,
      'renew': renew,
      'content': content,
      'month_price': monthPrice,
      'quarter_price': quarterPrice,
      'half_year_price': halfYearPrice,
      'year_price': yearPrice,
      'two_year_price': twoYearPrice,
      'three_year_price': threeYearPrice,
      'onetime_price': onetimePrice,
      'reset_price': resetPrice,
      'reset_traffic_method': resetTrafficMethod,
      'capacity_limit': capacityLimit,
      'speed_limit': speedLimit,
      'device_limit': deviceLimit,
    };
  }
  
  /// 获取指定周期的价格
  int? getPriceForPeriod(String period) {
    switch (period) {
      case 'month_price':
        return monthPrice;
      case 'quarter_price':
        return quarterPrice;
      case 'half_year_price':
        return halfYearPrice;
      case 'year_price':
        return yearPrice;
      case 'two_year_price':
        return twoYearPrice;
      case 'three_year_price':
        return threeYearPrice;
      case 'onetime_price':
        return onetimePrice;
      case 'reset_price':
        return resetPrice;
      default:
        return null;
    }
  }
  
  /// 是否显示
  bool get isVisible => show == 1;
  
  /// 是否可续费
  bool get isRenewable => renew == 1;
  
  /// 流量大小（GB）
  double? get transferGB {
    if (transferEnable == null) return null;
    return transferEnable! / 1024.0;
  }
}
