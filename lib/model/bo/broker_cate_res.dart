// ------------------------------------------------------
// author：suxing
// date  ：2020/11/21 下午5:23
// usage ：运营商商品类别信息
// ------------------------------------------------------

class BrokerCateRes {
  int broker_id;
  int cate_id;
  String cate_name;
  String created_at;
  int id;
  int sort_no;
  String update_at;
  int ver;

  BrokerCateRes({
    this.broker_id,
    this.cate_id,
    this.cate_name,
    this.created_at,
    this.id,
    this.sort_no,
    this.update_at,
    this.ver,
  });

  factory BrokerCateRes.fromJson(Map<String, dynamic> json) {
    return BrokerCateRes(
      broker_id: json['broker_id'],
      cate_id: json['cate_id'],
      cate_name: json['cate_name'],
      created_at: json['created_at'],
      id: json['id'],
      sort_no: json['sort_no'],
      update_at: json['update_at'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broker_id'] = this.broker_id;
    data['cate_id'] = this.cate_id;
    data['cate_name'] = this.cate_name;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['sort_no'] = this.sort_no;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    return data;
  }
}
