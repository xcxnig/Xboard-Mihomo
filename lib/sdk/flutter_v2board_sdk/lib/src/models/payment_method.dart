/// 支付方式数据模型
class PaymentMethod {
  final int id;
  final String? name;
  final String? payment;
  final String? icon;
  final int? show;
  final String? config;
  final int? handlingFeeFixed;
  final double? handlingFeePercent;
  
  PaymentMethod({
    required this.id,
    this.name,
    this.payment,
    this.icon,
    this.show,
    this.config,
    this.handlingFeeFixed,
    this.handlingFeePercent,
  });
  
  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as int,
      name: json['name'] as String?,
      payment: json['payment'] as String?,
      icon: json['icon'] as String?,
      show: json['show'] as int?,
      config: json['config'] as String?,
      handlingFeeFixed: json['handling_fee_fixed'] as int?,
      handlingFeePercent: (json['handling_fee_percent'] as num?)?.toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'payment': payment,
      'icon': icon,
      'show': show,
      'config': config,
      'handling_fee_fixed': handlingFeeFixed,
      'handling_fee_percent': handlingFeePercent,
    };
  }
  
  /// 是否显示
  bool get isVisible => show == 1;
  
  /// 计算手续费
  int calculateFee(int amount) {
    int fee = handlingFeeFixed ?? 0;
    if (handlingFeePercent != null) {
      fee += (amount * handlingFeePercent! / 100).round();
    }
    return fee;
  }
}
