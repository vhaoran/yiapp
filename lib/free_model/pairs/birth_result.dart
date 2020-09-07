// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 10:01
// usage ：生日配对结果
// ------------------------------------------------------

class BirthResult {
  String name; // 类如 1月1日出生的男的和1月2日出生的女的配吗？
  String oath; // 爱情誓言
  List<String> jiRi; // 各种吉日
  List<String> result; // 配对结果

  BirthResult({this.name, this.oath, this.jiRi, this.result});

  factory BirthResult.fromJson(Map<String, dynamic> json) {
    return BirthResult(
      name: json['name'],
      oath: json['oath'],
      jiRi: json['ji_ri'] != null ? List<String>.from(json['ji_ri']) : [],
      result: json['result'] != null ? List<String>.from(json['result']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['oath'] = this.oath;
    if (this.jiRi != null) {
      data['ji_ri'] = this.jiRi;
    }
    if (this.result != null) {
      data['result'] = this.result;
    }
    return data;
  }
}
