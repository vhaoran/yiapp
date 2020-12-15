// ------------------------------------------------------
// author：suxing
// date  ：2020/12/15 下午2:41
// usage ：运营商下面的大师信息
// ------------------------------------------------------

class BrokerMasterRes {
  int bad_rate;
  int best_rate;
  String brief;
  int broker_id;
  String broker_name;
  String created_at;
  int enabled;
  String icon;
  int level;
  int master_id;
  int mid_rate;
  String nick;
  int order_total;
  int rate;
  int rebate;
  String sign_date;
  int uid;
  String update_at;
  String user_code;
  int ver;

  BrokerMasterRes({
    this.bad_rate,
    this.best_rate,
    this.brief,
    this.broker_id,
    this.broker_name,
    this.created_at,
    this.enabled,
    this.icon,
    this.level,
    this.master_id,
    this.mid_rate,
    this.nick,
    this.order_total,
    this.rate,
    this.rebate,
    this.sign_date,
    this.uid,
    this.update_at,
    this.user_code,
    this.ver,
  });

  factory BrokerMasterRes.fromJson(Map<String, dynamic> json) {
    return BrokerMasterRes(
      bad_rate: json['bad_rate'],
      best_rate: json['best_rate'],
      brief: json['brief'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      created_at: json['created_at'],
      enabled: json['enabled'],
      icon: json['icon'],
      level: json['level'],
      master_id: json['master_id'],
      mid_rate: json['mid_rate'],
      nick: json['nick'],
      order_total: json['order_total'],
      rate: json['rate'],
      rebate: json['rebate'],
      sign_date: json['sign_date'],
      uid: json['uid'],
      update_at: json['update_at'],
      user_code: json['user_code'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bad_rate'] = this.bad_rate;
    data['best_rate'] = this.best_rate;
    data['brief'] = this.brief;
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['created_at'] = this.created_at;
    data['enabled'] = this.enabled;
    data['icon'] = this.icon;
    data['level'] = this.level;
    data['master_id'] = this.master_id;
    data['mid_rate'] = this.mid_rate;
    data['nick'] = this.nick;
    data['order_total'] = this.order_total;
    data['rate'] = this.rate;
    data['rebate'] = this.rebate;
    data['sign_date'] = this.sign_date;
    data['uid'] = this.uid;
    data['update_at'] = this.update_at;
    data['user_code'] = this.user_code;
    data['ver'] = this.ver;
    return data;
  }
}
