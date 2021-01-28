import 'package:yiapp/model/sizhu/sizhu_bazi.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/28 下午5:19
// usage ：四柱排盘结果
// ------------------------------------------------------

class SiZhuResult {
  SiZhuBaZi baZi;

  SiZhuResult({this.baZi});

  factory SiZhuResult.fromJson(Map<String, dynamic> json) {
    return SiZhuResult(
      baZi: json['bazi'] != null ? SiZhuBaZi.fromJson(json['bazi']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.baZi != null) {
      data['bazi'] = this.baZi.toJson();
    }
    return data;
  }
}
