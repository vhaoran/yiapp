// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/7 18:20
// usage : 大师服务项目
// ------------------------------------------------------

class MasterCate {
  //这个id基本无用，只用在删除时
  int iD;

  //uid
  int uid;

  //服务项目描述，大师可自己编辑
  String comment;

  //价格
  double price;

  //排序号，决定其在大师页中的显示 顺序
  int sort_no;

  //服务项目id
  int yi_cate_id;

  //服务项目名称
  String yi_cate_name;

  MasterCate(
      {this.comment,
      this.iD,
      this.price,
      this.sort_no,
      this.uid,
      this.yi_cate_id,
      this.yi_cate_name});

  factory MasterCate.fromJson(Map<String, dynamic> json) {
    return MasterCate(
      comment: json['comment'],
      iD: json['iD'],
      price: json['price'],
      sort_no: json['sort_no'],
      uid: json['uid'],
      yi_cate_id: json['yi_cate_id'],
      yi_cate_name: json['yi_cate_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['iD'] = this.iD;
    data['price'] = this.price;
    data['sort_no'] = this.sort_no;
    data['uid'] = this.uid;
    data['yi_cate_id'] = this.yi_cate_id;
    data['yi_cate_name'] = this.yi_cate_name;
    return data;
  }
}
