// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 17:14
// usage ：妈祖灵签结果
// ------------------------------------------------------

class MaZuResult {
  String dian_gu; // 典故
  String jie_qian; // 解签
  String name; // 签名
  String qian_ti; // 签题
  String qian_wen; // 签文
  List<String> yun_cheng; // 运程

  MaZuResult(
      {this.dian_gu,
      this.jie_qian,
      this.name,
      this.qian_ti,
      this.qian_wen,
      this.yun_cheng});

  factory MaZuResult.fromJson(Map<String, dynamic> json) {
    return MaZuResult(
      dian_gu: json['dian_gu'],
      jie_qian: json['jie_qian'],
      name: json['name'],
      qian_ti: json['qian_ti'],
      qian_wen: json['qian_wen'],
      yun_cheng:
          json['yun_cheng'] != null ? List<String>.from(json['yun_cheng']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dian_gu'] = this.dian_gu;
    data['jie_qian'] = this.jie_qian;
    data['name'] = this.name;
    data['qian_ti'] = this.qian_ti;
    data['qian_wen'] = this.qian_wen;
    if (this.yun_cheng != null) {
      data['yun_cheng'] = this.yun_cheng;
    }
    return data;
  }
}
