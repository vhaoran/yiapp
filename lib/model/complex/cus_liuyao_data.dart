import 'package:yiapp/model/liuyaos/liuyao_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/19 15:59
// usage ：自定义六爻数据格式
// ------------------------------------------------------

class CusLiuYaoData {
  final LiuYaoResult res;
  final List<int> codes; // 六爻编码

  String strCode = ""; // 字符串编码

  CusLiuYaoData({this.res, this.codes}) {
    if (codes != null && codes?.isNotEmpty) {
      codes.forEach((e) => strCode += e.toString());
    }
  }

  factory CusLiuYaoData.fromJson(Map<String, dynamic> json) {
    return CusLiuYaoData(
      res: json['res'] != null ? LiuYaoResult.fromJson(json['res']) : null,
      codes: (json['codes'] as List).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.res != null) {
      data['res'] = this.res.toJson();
      data['codes'] = this.codes.map((e) => e).toList();
    }
    return data;
  }
}
