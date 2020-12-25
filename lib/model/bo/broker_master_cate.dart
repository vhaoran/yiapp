// ------------------------------------------------------
// author：suxing
// date  ：2020/12/24 下午4:02
// usage ：用户获取运营商下面大师的服务项目
// ------------------------------------------------------

class BrokerMasterCate {
  int broker_id;
  String broker_name;
  int id;
  String master_icon;
  int master_id;
  String master_nick;
  int price;
  int yi_cate_id;
  String yi_cate_name;
  int sort_no;
  String comment;

  BrokerMasterCate({
    this.broker_id,
    this.broker_name,
    this.id,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.price,
    this.yi_cate_id,
    this.yi_cate_name,
    this.sort_no,
    this.comment,
  });

  factory BrokerMasterCate.fromJson(Map<String, dynamic> json) {
    return BrokerMasterCate(
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      id: json['id'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      price: json['price'],
      yi_cate_id: json['yi_cate_id'],
      yi_cate_name: json['yi_cate_name'],
      sort_no: json['sort_no'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['id'] = this.id;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['price'] = this.price;
    data['yi_cate_id'] = this.yi_cate_id;
    data['yi_cate_name'] = this.yi_cate_name;
    data['sort_no'] = this.sort_no;
    data['comment'] = this.comment;
    return data;
  }
}
