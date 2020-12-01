// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 11:09
// usage ：关帝灵签结果
// ------------------------------------------------------

class GuanDiResult {
  String bi_xian_zhu; // 碧仙注
  String dong_po_jie; // 东坡解
  String jie_qian; // 解签
  String jie_yue; // 解曰
  String name; // 签名 类如 关公灵签 第一百签: 癸癸 (上上) 赵阅道焚香告天
  String qian_ti; // 签题 类如 癸癸 (上上) 赵阅道焚香告天
  String sheng_yi; // 圣意
  String shi_yi; // 释义

  GuanDiResult(
      {this.bi_xian_zhu,
      this.dong_po_jie,
      this.jie_qian,
      this.jie_yue,
      this.name,
      this.qian_ti,
      this.sheng_yi,
      this.shi_yi});

  factory GuanDiResult.fromJson(Map<String, dynamic> json) {
    return GuanDiResult(
      bi_xian_zhu: json['bi_xian_zhu'],
      dong_po_jie: json['dong_po_jie'],
      jie_qian: json['jie_qian'],
      jie_yue: json['jie_yue'],
      name: json['name'],
      qian_ti: json['qian_ti'],
      sheng_yi: json['sheng_yi'],
      shi_yi: json['shi_yi'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['bi_xian_zhu'] = this.bi_xian_zhu;
    data['dong_po_jie'] = this.dong_po_jie;
    data['jie_qian'] = this.jie_qian;
    data['jie_yue'] = this.jie_yue;
    data['name'] = this.name;
    data['qian_ti'] = this.qian_ti;
    data['sheng_yi'] = this.sheng_yi;
    data['shi_yi'] = this.shi_yi;
    return data;
  }
}
