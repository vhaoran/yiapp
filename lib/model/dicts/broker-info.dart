// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 09:26
// usage : 代理商家
//
// ------------------------------------------------------
class BrokerInfo {
  int id;

  //主体名称
  String name;

  //主体简介
  String brief;

  //头像路径
  String icon;

  //推荐码
  String service_code;

  //提现帐号，只能来自微信或支付宝
  //0 支付宝 1：微信
  //只能是两者之一
  int accountType;

  //提现帐号
  String account_code;

  //使用平台商城 0:否 1：是
  int enableMall;

  //使用平台大师 0:否 1：是
  int enableMaster;

  //启用状态（0：停用 1：启用,默认启用）
  int enabled;

  //拥有者id,来自于userInfo
  int owner_id;
  String owner_icon;
  String owner_nick;
  String owner_user_code;

  String update_at;
  int ver;
  String created_at;

  BrokerInfo(
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
      this.update_at,
      this.ver});

  factory BrokerInfo.fromJson(Map<String, dynamic> json) {
    return BrokerInfo(
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
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    return data;
  }
}
