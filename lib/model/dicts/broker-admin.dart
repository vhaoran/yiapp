// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 10:33
// usage : 代理管理员，用于上加product,审核master等等
//
// ------------------------------------------------------
class BrokerAdmin {
  int id;

  //代理 id
  int broker_id;

  //0 active :1:stpp
  int enabled;

  //代理管理管理员id
  int uid;
  String icon;
  String nick;
  String user_code_ref;

  String update_at;
  String created_at;
  int ver;

  BrokerAdmin(
      {this.broker_id,
      this.created_at,
      this.enabled,
      this.icon,
      this.id,
      this.nick,
      this.uid,
      this.update_at,
      this.user_code_ref,
      this.ver});

  factory BrokerAdmin.fromJson(Map<String, dynamic> json) {
    return BrokerAdmin(
      broker_id: json['broker_id'],
      created_at: json['created_at'],
      enabled: json['enabled'],
      icon: json['icon'],
      id: json['id'],
      nick: json['nick'],
      uid: json['uid'],
      update_at: json['update_at'],
      user_code_ref: json['user_code_ref'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['broker_id'] = this.broker_id;
    data['created_at'] = this.created_at;
    data['enabled'] = this.enabled;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['nick'] = this.nick;
    data['uid'] = this.uid;
    data['update_at'] = this.update_at;
    data['user_code_ref'] = this.user_code_ref;
    data['ver'] = this.ver;
    return data;
  }
}
