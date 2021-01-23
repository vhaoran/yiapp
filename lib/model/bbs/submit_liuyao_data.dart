// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午8:53
// usage ：提交六爻的数据格式（含悬赏帖、闪断帖、大师亲测）
// ------------------------------------------------------
class SubmitLiuYaoData {
  int year;
  int month;
  int day;
  int hour;
  String yao_code;

  SubmitLiuYaoData({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.yao_code,
  });

  factory SubmitLiuYaoData.fromJson(Map<String, dynamic> json) {
    return SubmitLiuYaoData(
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      yao_code: json['yao_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['yao_code'] = this.yao_code;
    return data;
  }
}
