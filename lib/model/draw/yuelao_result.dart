// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 17:53
// usage ：月老灵签结果
// ------------------------------------------------------

class YueLaoResult {
  String jie_du; // 解读
  String jie_qian; // 解签
  String name; // 签名
  String qian_shi; // 签诗
  String qian_zhu; // 签注

  YueLaoResult({
    this.jie_du,
    this.jie_qian,
    this.name,
    this.qian_shi,
    this.qian_zhu,
  });

  factory YueLaoResult.fromJson(Map<String, dynamic> json) {
    return YueLaoResult(
      jie_du: json['jie_du'],
      jie_qian: json['jie_qian'],
      name: json['name'],
      qian_shi: json['qian_shi'],
      qian_zhu: json['qian_zhu'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['jie_du'] = this.jie_du;
    data['jie_qian'] = this.jie_qian;
    data['name'] = this.name;
    data['qian_shi'] = this.qian_shi;
    data['qian_zhu'] = this.qian_zhu;
    return data;
  }
}
