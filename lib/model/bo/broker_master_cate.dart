// ------------------------------------------------------
// author：suxing
// date  ：2020/12/24 下午4:02
// usage ：用户获取运营商下面大师的服务项目
// ------------------------------------------------------

class BrokerMasterCate {
  int broker_id;
  String broker_name;
  String created_at;
  int id;
  String master_icon;
  int master_id;
  String master_nick;
  int old_price;
  int price_offset;
  String update_at;
  int ver;
  int yi_cate_id;
  String yi_cate_name;

  BrokerMasterCate({
    this.broker_id,
    this.broker_name,
    this.created_at,
    this.id,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.old_price,
    this.price_offset,
    this.update_at,
    this.ver,
    this.yi_cate_id,
    this.yi_cate_name,
  });

  factory BrokerMasterCate.fromJson(Map<String, dynamic> json) {
    return BrokerMasterCate(
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      created_at: json['created_at'],
      id: json['id'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      old_price: json['old_price'],
      price_offset: json['price_offset'],
      update_at: json['update_at'],
      ver: json['ver'],
      yi_cate_id: json['yi_cate_id'],
      yi_cate_name: json['yi_cate_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['old_price'] = this.old_price;
    data['price_offset'] = this.price_offset;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    data['yi_cate_id'] = this.yi_cate_id;
    data['yi_cate_name'] = this.yi_cate_name;
    return data;
  }
}
