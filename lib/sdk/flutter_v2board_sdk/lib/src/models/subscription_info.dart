/// 订阅信息数据模型
class SubscriptionInfo {
  final String? subscribeUrl;
  final String? token;
  
  SubscriptionInfo({
    this.subscribeUrl,
    this.token,
  });
  
  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      subscribeUrl: json['subscribe_url'] as String?,
      token: json['token'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'subscribe_url': subscribeUrl,
      'token': token,
    };
  }
}
