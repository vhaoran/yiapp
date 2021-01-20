// ------------------------------------------------------
// author：suxing
// date  ：2021/1/20 下午2:17
// usage ：代理商家的信息
// ------------------------------------------------------

class BrokerInfo {
  String account_code;
  int account_type;
  String brief;
  String created_at;
  int enable_mall;
  int enable_master;
  int enable_prize;
  int enable_vie;
  int enabled;
  String icon;
  int id; // 运营商的 broker_id
  String name;
  String owner_icon;
  int owner_id; // 运营商的uid
  String owner_nick;
  String owner_user_code;
  String service_code; // 运营商的服务码
  String update_at;
  int ver;

  BrokerInfo({
    this.account_code,
    this.account_type,
    this.brief,
    this.created_at,
    this.enable_mall,
    this.enable_master,
    this.enable_prize,
    this.enable_vie,
    this.enabled,
    this.icon,
    this.id,
    this.name,
    this.owner_icon,
    this.owner_id,
    this.owner_nick,
    this.owner_user_code,
    this.service_code,
    this.update_at,
    this.ver,
  });

  factory BrokerInfo.fromJson(Map<String, dynamic> json) {
    return BrokerInfo(
      account_code: json['account_code'],
      account_type: json['account_type'],
      brief: json['brief'],
      created_at: json['created_at'],
      enable_mall: json['enable_mall'],
      enable_master: json['enable_master'],
      enable_prize: json['enable_prize'],
      enable_vie: json['enable_vie'],
      enabled: json['enabled'],
      icon: json['icon'],
      id: json['id'],
      name: json['name'],
      owner_icon: json['owner_icon'],
      owner_id: json['owner_id'],
      owner_nick: json['owner_nick'],
      owner_user_code: json['owner_user_code'],
      service_code: json['service_code'],
      update_at: json['update_at'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['account_code'] = this.account_code;
    data['account_type'] = this.account_type;
    data['brief'] = this.brief;
    data['created_at'] = this.created_at;
    data['enable_mall'] = this.enable_mall;
    data['enable_master'] = this.enable_master;
    data['enable_prize'] = this.enable_prize;
    data['enable_vie'] = this.enable_vie;
    data['enabled'] = this.enabled;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['owner_icon'] = this.owner_icon;
    data['owner_id'] = this.owner_id;
    data['owner_nick'] = this.owner_nick;
    data['owner_user_code'] = this.owner_user_code;
    data['service_code'] = this.service_code;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    return data;
  }
}
