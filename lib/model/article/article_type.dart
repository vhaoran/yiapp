// ------------------------------------------------------
// author：suxing
// date  ：2020/10/10 09:35
// usage ：文章类别 目前只有 1 四柱、2 六爻、3 星座、4 血型、5 其他
// ------------------------------------------------------

class ArticleType {
  int id;
  String created_at;
  String name;
  int sort_no;
  String update_at;
  int ver;

  ArticleType({
    this.id,
    this.created_at,
    this.name,
    this.sort_no,
    this.update_at,
    this.ver,
  });

  factory ArticleType.fromJson(Map<String, dynamic> json) {
    return ArticleType(
      id: json['ID'],
      created_at: json['created_at'],
      name: json['name'],
      sort_no: json['sort_no'],
      update_at: json['update_at'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['created_at'] = this.created_at;
    data['name'] = this.name;
    data['sort_no'] = this.sort_no;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    return data;
  }
}
