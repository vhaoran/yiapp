// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午11:26
// usage ：大师对账单结果
// ------------------------------------------------------

class MasterBusinessRes {
  int amt;
  int amt_start;
  String b_type;
  String bill_no;
  String created_at;
  String icon;
  int id;
  String nick;
  String remark;
  String summary;
  int uid;
  String update_at;
  int ver;

  MasterBusinessRes({
    this.amt,
    this.amt_start,
    this.b_type,
    this.bill_no,
    this.created_at,
    this.icon,
    this.id,
    this.nick,
    this.remark,
    this.summary,
    this.uid,
    this.update_at,
    this.ver,
  });

  factory MasterBusinessRes.fromJson(Map<String, dynamic> json) {
    return MasterBusinessRes(
      amt: json['amt'],
      amt_start: json['amt_start'],
      b_type: json['b_type'],
      bill_no: json['bill_no'],
      created_at: json['created_at'],
      icon: json['icon'],
      id: json['id'],
      nick: json['nick'],
      remark: json['remark'],
      summary: json['summary'],
      uid: json['uid'],
      update_at: json['update_at'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amt'] = this.amt;
    data['amt_start'] = this.amt_start;
    data['b_type'] = this.b_type;
    data['bill_no'] = this.bill_no;
    data['created_at'] = this.created_at;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['nick'] = this.nick;
    data['remark'] = this.remark;
    data['summary'] = this.summary;
    data['uid'] = this.uid;
    data['update_at'] = this.update_at;
    data['ver'] = this.ver;
    return data;
  }
}
