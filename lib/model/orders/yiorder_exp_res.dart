// ------------------------------------------------------
// author：suxing
// date  ：2020/12/30 下午5:22
// usage ：大师订单评价结果
// ------------------------------------------------------

class YiOrderExpRes {
  int broker_id;
  String broker_name;
  String create_date;
  int create_date_int;
  int exp_result;
  String exp_text;
  String icon;
  String id;
  String master_icon;
  int master_id;
  String master_nick;
  String nick;
  String order_id;
  int uid;

  YiOrderExpRes({
    this.broker_id,
    this.broker_name,
    this.create_date,
    this.create_date_int,
    this.exp_result,
    this.exp_text,
    this.icon,
    this.id,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.nick,
    this.order_id,
    this.uid,
  });

  factory YiOrderExpRes.fromJson(Map<String, dynamic> json) {
    return YiOrderExpRes(
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      create_date: json['create_date'],
      create_date_int: json['create_date_int'],
      exp_result: json['exp_result'],
      exp_text: json['exp_text'],
      icon: json['icon'],
      id: json['id'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      nick: json['nick'],
      order_id: json['order_id'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['create_date'] = this.create_date;
    data['create_date_int'] = this.create_date_int;
    data['exp_result'] = this.exp_result;
    data['exp_text'] = this.exp_text;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['nick'] = this.nick;
    data['order_id'] = this.order_id;
    data['uid'] = this.uid;
    return data;
  }
}
