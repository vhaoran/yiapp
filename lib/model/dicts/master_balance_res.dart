// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午10:50
// usage ：获取大师余额
// ------------------------------------------------------

class MasterBalanceRes {
  int master_id;
  num remainder;

  MasterBalanceRes({this.master_id, this.remainder});

  factory MasterBalanceRes.fromJson(Map<String, dynamic> json) {
    return MasterBalanceRes(
      master_id: json['master_id'],
      remainder: json['remainder'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['master_id'] = this.master_id;
    data['remainder'] = this.remainder;
    return data;
  }
}
