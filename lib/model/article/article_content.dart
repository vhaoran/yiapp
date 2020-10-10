// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 10:19
// usage ：单篇文章的内容
// ------------------------------------------------------

class ArticleContent {
  String content;
  int type; // 0 文字 1 图片

  ArticleContent({this.content, this.type});

  factory ArticleContent.fromJson(Map<String, dynamic> json) {
    return ArticleContent(
      content: json['content'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['type'] = this.type;
    return data;
  }
}
