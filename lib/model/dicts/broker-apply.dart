// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 10:58
// usage : 代理申请
// 字段含义 参考 brokerInfo
// ------------------------------------------------------

class BrokerApply {
  int id;
  int accountType;
  String account_code;
  String brief;
  int enableMall;
  int enableMaster;
  int enabled;
  String icon;
  String name;
  String owner_icon;

  int owner_id;
  String owner_nick;
  String owner_user_code;

  String service_code;
  int stat;

  String created_at;
  String update_at;
  int ver;

  BrokerApply(
      {this.accountType,
      this.account_code,
      this.brief,
      this.created_at,
      this.enableMall,
      this.enableMaster,
      this.enabled,
      this.icon,
      this.id,
      this.name,
      this.owner_icon,
      this.owner_id,
      this.owner_nick,
      this.owner_user_code,
      this.service_code,
      this.stat,
      this.update_at,
      this.ver});

  factory BrokerApply.fromJson(Map<String, dynamic> json) {
    return BrokerApply(
      accountType: json['accountType'],
      account_code: json['account_code'],
      brief: json['brief'],
      created_at: json['created_at'],
      enableMall: json['enableMall'],
      enableMaster: json['enableMaster'],
      enabled: json['enabled'],
      icon: json['icon'],
      id: json['id'],
      name: json['name'],
      owner_icon: json['owner_icon'],
      owner_id: json['owner_id'],
      owner_nick: json['owner_nick'],
      owner_user_code: json['owner_user_code'],
      service_code: json['service_code'],
      stat: json['stat'],
      update_at: json['update_at'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountType'] = this.accountType;
    data['account_code'] = this.account_code;
    data['brief'] = this.brief;
    data['created_at'] = this.created_at;
    data['enableMall'] = this.enableMall;
    data['enableMaster'] = this.enableMaster;
    data['enabled'] = this.enabled;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['owner_icon'] = this.owner_icon;
    data['owner_id'] = this.owner_id;
    data['owner_nick'] = this.owner_nick;
    data['owner_user_code'] = this.owner_user_code;
    data['service_code'] = this.service_code;
    data['stat'] = this.stat;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    return data;
  }
}
