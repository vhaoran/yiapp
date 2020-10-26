// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 11:43
// usage ：周公数据实体类
// ------------------------------------------------------

class ZhouGongRes {
  String code;
  List<String> content;
  String key_word;
  String title;

  ZhouGongRes({this.code, this.content, this.key_word, this.title});

  factory ZhouGongRes.fromJson(Map<String, dynamic> json) {
    return ZhouGongRes(
      code: json['code'],
      content:
          json['content'] != null ? List<String>.from(json['content']) : null,
      key_word: json['key_word'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['key_word'] = this.key_word;
    data['title'] = this.title;
    if (this.content != null) {
      data['content'] = this.content;
    }
    return data;
  }
}
