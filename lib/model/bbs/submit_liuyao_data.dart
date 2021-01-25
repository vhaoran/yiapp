import 'package:yiapp/model/orders/liuyao_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午8:53
// usage ：提交六爻的数据格式（含悬赏帖、闪断帖、大师亲测）
// ------------------------------------------------------

class SubmitLiuYaoData {
  num amt;
  int level_id;
  String title;
  String brief;
  int content_type;
  LiuYaoContent content;

  SubmitLiuYaoData({
    this.amt,
    this.level_id,
    this.title,
    this.brief,
    this.content_type,
    this.content,
  });

  factory SubmitLiuYaoData.fromJson(Map<String, dynamic> json) {
    return SubmitLiuYaoData(
      amt: json['amt'],
      level_id: json['level_id'],
      title: json['title'],
      brief: json['brief'],
      content_type: json['content_type'],
      content: json['content'] != null
          ? LiuYaoContent.fromJson(json['content'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amt'] = this.amt;
    data['level_id'] = this.level_id;
    data['title'] = this.title;
    data['brief'] = this.brief;
    data['content_type'] = this.content_type;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}
