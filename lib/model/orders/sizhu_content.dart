// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午2:47
// usage ：四柱 content 的内容
// ------------------------------------------------------

class SiZhuContent {
  bool is_solar;
  String name; // 姓名，可以没有
  bool is_male;
  int year;
  int month;
  int day;
  int hour;
  int minute;

  SiZhuContent({
    this.is_solar,
    this.name,
    this.is_male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
  });

  factory SiZhuContent.fromJson(Map<String, dynamic> json) {
    return SiZhuContent(
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
  DateTime toDateTime() {
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
