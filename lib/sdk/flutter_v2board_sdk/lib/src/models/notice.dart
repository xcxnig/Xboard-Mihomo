/// 公告数据模型
class Notice {
  final int? id;
  final String? title;
  final String? content;
  final int? show;
  final String? imgUrl;
  final int? createdAt;
  final int? updatedAt;
  
  Notice({
    this.id,
    this.title,
    this.content,
    this.show,
    this.imgUrl,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      show: json['show'] as int?,
      imgUrl: json['img_url'] as String?,
      createdAt: json['created_at'] as int?,
      updatedAt: json['updated_at'] as int?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'show': show,
      'img_url': imgUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
  
  /// 是否显示
  bool get isVisible => show == 1;
}
