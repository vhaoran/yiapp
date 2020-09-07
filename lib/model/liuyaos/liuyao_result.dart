import 'liuyao_riqi.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 11:34
// usage ：六爻排盘结果
// ------------------------------------------------------

class LiuYaoResult {
  List<String> fushen;
  List<String> l;
  List<String> l_bian;
  List<String> liushen;
  String name;
  String name_bian;
  LiuYaoRiqi riqi;

  LiuYaoResult({
    this.fushen,
    this.l,
    this.l_bian,
    this.liushen,
    this.name,
    this.name_bian,
    this.riqi,
  });

  factory LiuYaoResult.fromJson(Map<String, dynamic> json) {
    return LiuYaoResult(
      fushen: json['fushen'] != null ? List<String>.from(json['fushen']) : [],
      l: json['l'] != null ? List<String>.from(json['l']) : [],
      l_bian: json['l_bian'] != null ? List<String>.from(json['l_bian']) : [],
      liushen:
          json['liushen'] != null ? List<String>.from(json['liushen']) : [],
      name: json['name'],
      name_bian: json['name_bian'],
      riqi: json['riqi'] != null
          ? LiuYaoRiqi.fromJson(json['riqi'])
          : LiuYaoRiqi(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['name_bian'] = this.name_bian;
    if (this.fushen != null) {
      data['fushen'] = this.fushen;
    }
    if (this.l != null) {
      data['l'] = this.l;
    }
    if (this.l_bian != null) {
      data['l_bian'] = this.l_bian;
    }
    if (this.liushen != null) {
      data['liushen'] = this.liushen;
    }
    if (this.riqi != null) {
      data['riqi'] = this.riqi.toJson();
    }
    return data;
  }
}
