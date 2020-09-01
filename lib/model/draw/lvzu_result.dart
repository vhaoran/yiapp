// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 18:12
// usage ：吕祖灵签结果
// ------------------------------------------------------

class LvZuResult {
  String gai_shu; // 概述
  String jie_shi; // 解诗
  String name; // 签名
  String qian_wen; // 签文
  String shi_yue; // 诗曰
  List<String> yun_cheng; // 运程

  LvZuResult(
      {this.gai_shu,
      this.jie_shi,
      this.name,
      this.qian_wen,
      this.shi_yue,
      this.yun_cheng});

  factory LvZuResult.fromJson(Map<String, dynamic> json) {
    return LvZuResult(
      gai_shu: json['gai_shu'],
      jie_shi: json['jie_shi'],
      name: json['name'],
      qian_wen: json['qian_wen'],
      shi_yue: json['shi_yue'],
      yun_cheng: json['yun_cheng'] != null
          ? List<String>.from(json['yun_cheng'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['gai_shu'] = this.gai_shu;
    data['jie_shi'] = this.jie_shi;
    data['name'] = this.name;
    data['qian_wen'] = this.qian_wen;
    data['shi_yue'] = this.shi_yue;
    if (this.yun_cheng != null) {
      data['yun_cheng'] = this.yun_cheng;
    }
    return data;
  }
}
