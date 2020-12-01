// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 17:45
// usage ：黄大仙灵签结果
// ------------------------------------------------------

class DaXianResult {
  String jie_qian; // 解签
  List<String> jie_yun_shi; // 解运势
  String name; // 签名
  List<String> qian_shi; // 签诗

  DaXianResult({
    this.jie_qian,
    this.jie_yun_shi,
    this.name,
    this.qian_shi,
  });

  factory DaXianResult.fromJson(Map<String, dynamic> json) {
    return DaXianResult(
      jie_qian: json['jie_qian'],
      jie_yun_shi: json['jie_yun_shi'] != null
          ? List<String>.from(json['jie_yun_shi'])
          : [],
      name: json['name'],
      qian_shi:
          json['qian_shi'] != null ? List<String>.from(json['qian_shi']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['jie_qian'] = this.jie_qian;
    data['name'] = this.name;
    if (this.qian_shi != null) {
      data['qian_shi'] = this.qian_shi;
    }
    if (this.jie_yun_shi != null) {
      data['jie_yun_shi'] = this.jie_yun_shi;
    }
    return data;
  }
}
