// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 09:51
// usage : 用户支付帐号相关信息
// ------------------------------------------------------

class Account {
  int id;
  int uid;
  String nick_ref;
  String icon_ref;

  //帐号类型    0：支付宝 1：微信
  int account_type;

  //资金帐号
  String account_code;

  //是否默认帐号 0:是 1:否，一人只能有一个默认账号
  int is_default;

  String update_at;
  String created_at;
  String user_code_ref;
  int ver;

  Account(
      {this.account_code,
      this.account_type,
      this.created_at,
      this.icon_ref,
      this.id,
      this.is_default,
      this.nick_ref,
      this.uid,
      this.update_at,
      this.user_code_ref,
      this.ver});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      account_code: json['account_code'],
      account_type: json['account_type'],
      created_at: json['created_at'],
      icon_ref: json['icon_ref'],
      id: json['id'],
      is_default: json['is_default'],
      nick_ref: json['nick_ref'],
      uid: json['uid'],
      update_at: json['update_at'],
      user_code_ref: json['user_code_ref'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_code'] = this.account_code;
    data['account_type'] = this.account_type;
    data['created_at'] = this.created_at;
    data['icon_ref'] = this.icon_ref;
    data['id'] = this.id;
    data['is_default'] = this.is_default;
    data['nick_ref'] = this.nick_ref;
    data['uid'] = this.uid;
    data['update_at'] = this.update_at;
    data['user_code_ref'] = this.user_code_ref;
    data['ver'] = this.ver;
    return data;
  }
}
