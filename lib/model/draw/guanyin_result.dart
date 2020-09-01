// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 16:49
// usage ：观音灵签结果
// ------------------------------------------------------

class GuanYinResult {
  String dian_gu; // 典故
  String gong_wei; // 宫位
  String jie_yue; // 解曰
  String name; // 签名，类如 观音灵签 七三签: 陈桥兵变(上签)
  String shi_yi; // 诗意
  String xian_ji; // 仙机

  GuanYinResult(
      {this.dian_gu,
      this.gong_wei,
      this.jie_yue,
      this.name,
      this.shi_yi,
      this.xian_ji});

  factory GuanYinResult.fromJson(Map<String, dynamic> json) {
    return GuanYinResult(
      dian_gu: json['dian_gu'],
      gong_wei: json['gong_wei'],
      jie_yue: json['jie_yue'],
      name: json['name'],
      shi_yi: json['shi_yi'],
      xian_ji: json['xian_ji'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dian_gu'] = this.dian_gu;
    data['gong_wei'] = this.gong_wei;
    data['jie_yue'] = this.jie_yue;
    data['name'] = this.name;
    data['shi_yi'] = this.shi_yi;
    data['xian_ji'] = this.xian_ji;
    return data;
  }
}
