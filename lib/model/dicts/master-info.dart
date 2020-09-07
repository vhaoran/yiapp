// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/7 18:18
// usage : //大师基本信息
// ------------------------------------------------------
class MasterInfo {
  int bad_rate;
  int best_rate;
  String created_at;
  int enabled;
  int iD;
  String icon;
  int level;
  int mid_rate;
  String nick;
  int order_total;
  int rate;
  String sign_date;
  int uid;
  String update_at;
  String user_code;
  int ver;

  MasterInfo(
      {this.bad_rate,
      this.best_rate,
      this.created_at,
      this.enabled,
      this.iD,
      this.icon,
      this.level,
      this.mid_rate,
      this.nick,
      this.order_total,
      this.rate,
      this.sign_date,
      this.uid,
      this.update_at,
      this.user_code,
      this.ver});

  factory MasterInfo.fromJson(Map<String, dynamic> json) {
    return MasterInfo(
      bad_rate: json['bad_rate'],
      best_rate: json['best_rate'],
      created_at: json['created_at'],
      enabled: json['enabled'],
      iD: json['iD'],
      icon: json['icon'],
      level: json['level'],
      mid_rate: json['mid_rate'],
      nick: json['nick'],
      order_total: json['order_total'],
      rate: json['rate'],
      sign_date: json['sign_date'],
      uid: json['uid'],
      update_at: json['update_at'],
      user_code: json['user_code'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bad_rate'] = this.bad_rate;
    data['best_rate'] = this.best_rate;
    data['created_at'] = this.created_at;
    data['enabled'] = this.enabled;
    data['iD'] = this.iD;
    data['icon'] = this.icon;
    data['level'] = this.level;
    data['mid_rate'] = this.mid_rate;
    data['nick'] = this.nick;
    data['order_total'] = this.order_total;
    data['rate'] = this.rate;
    data['sign_date'] = this.sign_date;
    data['uid'] = this.uid;
    data['update_at'] = this.update_at;
    data['user_code'] = this.user_code;
    data['ver'] = this.ver;
    return data;
  }
}
