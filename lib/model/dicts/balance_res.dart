// ------------------------------------------------------
// author：suxing
// date  ：2020/12/9 上午11:49
// usage ：获取本人余额
// ------------------------------------------------------
class BalanceRes {
  int uid;
  num remainder; // 余额

  BalanceRes({this.uid, this.remainder});

  factory BalanceRes.fromJson(Map<String, dynamic> json) {
    return BalanceRes(uid: json['uid'], remainder: json['remainder']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = this.uid;
    data['remainder'] = this.remainder;
    return data;
  }
}
