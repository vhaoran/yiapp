// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 18:03
// usage ：车公灵签结果
// ------------------------------------------------------

class CheGongResult {
  String jie_qian; // 解签
  String name; // 签名
  String qian_wen; // 签文
  List<String> qian_yun; // 签运

  CheGongResult({
    this.jie_qian,
    this.name,
    this.qian_wen,
    this.qian_yun,
  });

  factory CheGongResult.fromJson(Map<String, dynamic> json) {
    return CheGongResult(
      jie_qian: json['jie_qian'],
      name: json['name'],
      qian_wen: json['qian_wen'],
      qian_yun:
          json['qian_yun'] != null ? List<String>.from(json['qian_yun']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['jie_qian'] = this.jie_qian;
    data['name'] = this.name;
    data['qian_wen'] = this.qian_wen;
    if (this.qian_yun != null) {
      data['qian_yun'] = this.qian_yun;
    }
    return data;
  }
}
