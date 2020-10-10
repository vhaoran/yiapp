// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 10:32
// usage ：某一类文章的结果
// ------------------------------------------------------

class ArticleTypeRes {
  int id;
  String article_id;
  int cate_id;
  String created_at;
  String title;
  String update_at;
  int ver;
  int visit_count;

  ArticleTypeRes({
    this.id,
    this.article_id,
    this.cate_id,
    this.created_at,
    this.title,
    this.update_at,
    this.ver,
    this.visit_count,
  });

  factory ArticleTypeRes.fromJson(Map<String, dynamic> json) {
    return ArticleTypeRes(
      id: json['ID'],
      article_id: json['article_id'],
      cate_id: json['cate_id'],
      created_at: json['created_at'],
      title: json['title'],
      update_at: json['update_at'],
      ver: json['ver'],
      visit_count: json['visit_count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['article_id'] = this.article_id;
    data['cate_id'] = this.cate_id;
    data['created_at'] = this.created_at;
    data['title'] = this.title;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    data['visit_count'] = this.visit_count;
    return data;
  }
}
