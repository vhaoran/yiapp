// ------------------------------------------------------
// author：suxing
// date  ：2020/8/26 11:11
// usage ：星座配对结果
// ------------------------------------------------------

class ConResult {
  String con_day; // 最佳表白日
  String feel; // 爱情情缘
  String gem; // 定情宝石
  String name; // 白羊男+金牛女
  String oath; // 爱情宣言
  String parse; // 解析
  List<String> stars; // 配对指数

  ConResult(
      {this.con_day,
      this.feel,
      this.gem,
      this.name,
      this.oath,
      this.parse,
      this.stars});

  ConResult.fromJson(Map<String, dynamic> json) {
    this.con_day = json['con_day'];
    this.feel = json['feel'];
    this.gem = json['gem'];
    this.name = json['name'];
    this.oath = json['oath'];
    this.parse = json['parse'];
    this.stars = json['stars'] != null ? List<String>.from(json['stars']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['con_day'] = this.con_day;
    data['feel'] = this.feel;
    data['gem'] = this.gem;
    data['name'] = this.name;
    data['oath'] = this.oath;
    data['parse'] = this.parse;
    if (this.stars != null) {
      data['stars'] = this.stars;
    }
    return data;
  }
}
