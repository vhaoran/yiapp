import 'package:yiapp/model/orders/hehun_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午8:55
// usage ：提交合婚的数据格式（含悬赏帖、闪断帖、大师亲测）
// ------------------------------------------------------

class SubmitHeHunData {
  num amt;
  int level_id;
  String title;
  String brief;
  int content_type;
  HeHunContent content;

  SubmitHeHunData({
    this.amt,
    this.level_id,
    this.title,
    this.brief,
    this.content_type,
    this.content,
  });

  factory SubmitHeHunData.fromJson(Map<String, dynamic> json) {
    return SubmitHeHunData(
      amt: json['amt'],
      level_id: json['level_id'],
      title: json['title'],
      brief: json['brief'],
      content_type: json['content_type'],
      content: json['content'] != null
          ? HeHunContent.fromJson(json['content'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
