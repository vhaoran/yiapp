// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 16:06
// usage ：血型配对结果
// ------------------------------------------------------

class BloodResult {
  String advantage; // 彼此吸引点
  String confession_day; // 最佳表白日
  String disadvantage; // 可能出现的问题
  String name; // A型血男+A型血女
  String oath; // 爱情誓言
  String plus; // 增进感情的方式

  BloodResult(
      {this.advantage,
      this.confession_day,
      this.disadvantage,
      this.name,
      this.oath,
      this.plus});

  factory BloodResult.fromJson(Map<String, dynamic> json) {
    return BloodResult(
      advantage: json['advantage'],
      confession_day: json['confession_day'],
      disadvantage: json['disadvantage'],
      name: json['name'],
      oath: json['oath'],
      plus: json['plus'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advantage'] = this.advantage;
    data['confession_day'] = this.confession_day;
    data['disadvantage'] = this.disadvantage;
    data['name'] = this.name;
    data['oath'] = this.oath;
    data['plus'] = this.plus;
    return data;
  }
}
