import 'article_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 10:20
// usage ：查询文章
// ------------------------------------------------------

class ArticleResult {
  int cate_id;
  String code;
  List<ArticleContent> content;
  String key_word;
  String title;

  ArticleResult({
    this.cate_id,
    this.code,
    this.content,
    this.key_word,
    this.title,
  });

  factory ArticleResult.fromJson(Map<String, dynamic> json) {
    return ArticleResult(
      cate_id: json['cate_id'],
      code: json['code'],
      content: json['content'] != null
          ? (json['content'] as List)
              .map((i) => ArticleContent.fromJson(i))
              .toList()
          : null,
      key_word: json['key_word'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cate_id'] = this.cate_id;
    data['code'] = this.code;
    data['key_word'] = this.key_word;
    data['title'] = this.title;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
