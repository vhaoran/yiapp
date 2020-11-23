// ------------------------------------------------------
// author：suxing
// date  ：2020/11/23 下午6:18
// usage ：订单支付数据格式
// ------------------------------------------------------

class PayData {
  int amt; // 支付金额
  String b_type; // 订单类型
  String id;

  PayData({this.amt, this.b_type, this.id});

  factory PayData.fromJson(Map<String, dynamic> json) {
    return PayData(
      amt: json['amt'],
      b_type: json['b_type'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['amt'] = this.amt;
    data['b_type'] = this.b_type;
    data['id'] = this.id;
    return data;
  }
}
