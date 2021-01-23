// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午5:41
// usage ：六爻格式
// ------------------------------------------------------

class LiuYaoRes {
  String yao_code; //  卦的代码
  // 这是公历表示的日期
  bool is_male;
  int year;
  int month;
  int day;
  int hour;
  int minute;

  LiuYaoRes({
    this.yao_code,
    this.is_male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
  });

  factory LiuYaoRes.fromJson(Map<String, dynamic> json) {
    return LiuYaoRes(
      yao_code: json['yao_code'],
      is_male: json['is_male'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['yao_code'] = this.yao_code;
    data['is_male'] = this.is_male;
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    return data;
  }

  /// 返回的时间数据转换为 DateTime
  DateTime dateTime() {
    return DateTime(this.year, this.month, this.day, this.hour, this.minute);
  }

  /// 根据选择的时间，为数据赋值
  void ymdhm(DateTime date) {
    this.year = date.year;
    this.month = date.month;
    this.day = date.day;
    this.hour = date.hour;
    this.minute = date.minute;
  }
}
