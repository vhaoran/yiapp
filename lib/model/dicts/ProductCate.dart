// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 17:45
// usage : 商城 商品 分类
//
// ------------------------------------------------------
class Category {
  int id;
  String name;
  String icon;
  int sort_no;

  Category({this.icon, this.id, this.name, this.sort_no});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      icon: json['icon'],
      id: json['id'],
      name: json['name'],
      sort_no: json['sort_no'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['sort_no'] = this.sort_no;
    return data;
  }
}
