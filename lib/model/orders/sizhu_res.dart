// ------------------------------------------------------
// author：suxing
// date  ：2020/12/28 下午3:14
// usage ：大师订单内容 -- 排四柱
// ------------------------------------------------------

class SiZhuRes {
  bool is_solar;
  String name; // 姓名，可以没有
  bool is_male;
  int year;
  int month;
  int day;
  int hour;
  int minute;

  SiZhuRes({
    this.is_solar,
    this.name,
    this.is_male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
  });

  factory SiZhuRes.fromJson(Map<String, dynamic> json) {
    return SiZhuRes(
      is_solar: json['is_solar'],
      name: json['name'],
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
    data['is_solar'] = this.is_solar;
    data['name'] = this.name;
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
