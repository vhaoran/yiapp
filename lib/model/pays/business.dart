class Business {
  int id;

  int uid;
  String user_code_ref;
  String icon_ref;
  String nick_ref;

  int action;
  num amt_start;
  num amt;
  String summary;
  String tradeNo;

  String created_at;
  String update_at;
  int ver;

  Business(
      {this.action,
      this.amt,
      this.amt_start,
      this.created_at,
      this.icon_ref,
      this.id,
      this.nick_ref,
      this.summary,
      this.tradeNo,
      this.uid,
      this.update_at,
      this.user_code_ref,
      this.ver});

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      action: json['Action'],
      amt: json['Amt'],
      amt_start: json['AmtStart'],
      created_at: json['created_at'],
      icon_ref: json['icon_ref'],
      id: json['id'],
      nick_ref: json['nick_ref'],
      summary: json['Summary'],
      tradeNo: json['TradeNo'],
      uid: json['uid'],
      update_at: json['update_at'],
      user_code_ref: json['user_code_ref'],
      ver: json['ver'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Action'] = this.action;
    data['Amt'] = this.amt;
    data['AmtStart'] = this.amt_start;
    data['created_at'] = this.created_at;
    data['icon_ref'] = this.icon_ref;
    data['id'] = this.id;
    data['nick_ref'] = this.nick_ref;
    data['Summary'] = this.summary;
    data['TradeNo'] = this.tradeNo;
    data['uid'] = this.uid;
    data['update_at'] = this.update_at;
    data['user_code_ref'] = this.user_code_ref;
    data['ver'] = this.ver;
    return data;
  }
}
