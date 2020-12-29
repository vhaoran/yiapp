// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午4:08
// usage ：大师订单内容 -- 合婚
// ------------------------------------------------------

class YiOrderHeHun {
  // male 男方
  String name_male;
  bool is_solar_male;
  int year_male;
  int month_male;
  int day_male;
  int hour_male;
  int minute_male;
  // female 女方
  String name_female;
  bool is_solar_female;
  int year_female;
  int month_female;
  int day_female;
  int hour_female;
  int minute_female;

  YiOrderHeHun({
    this.name_male,
    this.is_solar_male,
    this.year_male,
    this.month_male,
    this.day_male,
    this.hour_male,
    this.minute_male,
    this.name_female,
    this.is_solar_female,
    this.year_female,
    this.month_female,
    this.day_female,
    this.hour_female,
    this.minute_female,
  });

  factory YiOrderHeHun.fromJson(Map<String, dynamic> json) {
    return YiOrderHeHun(
      name_male: json['name_male'],
      is_solar_male: json['is_solar_male'],
      year_male: json['year_male'],
      month_male: json['month_male'],
      day_male: json['day_male'],
      hour_male: json['hour_male'],
      minute_male: json['minute_male'],
      name_female: json['name_female'],
      is_solar_female: json['is_solar_female'],
      year_female: json['year_female'],
      month_female: json['month_female'],
      day_female: json['day_female'],
      hour_female: json['hour_female'],
      minute_female: json['minute_female'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name_male'] = this.name_male;
    data['is_solar_male'] = this.is_solar_male;
    data['year_male'] = this.year_male;
    data['month_male'] = this.month_male;
    data['day_male'] = this.day_male;
    data['hour_male'] = this.hour_male;
    data['minute_male'] = this.minute_male;
    data['name_female'] = this.name_female;
    data['is_solar_female'] = this.is_solar_female;
    data['year_female'] = this.year_female;
    data['month_female'] = this.month_female;
    data['day_female'] = this.day_female;
    data['hour_female'] = this.hour_female;
    data['minute_female'] = this.minute_female;
    return data;
  }

  /// 将数据转换为 DateTime
  DateTime dateTime(bool isMale) {
    if (isMale) {
      return DateTime(year_male, month_male, day_male, hour_male, minute_male);
    }
    return DateTime(
        year_female, month_female, day_female, hour_female, minute_female);
  }

  /// 根据选择的时间，为数据赋值
  void ymdhm(DateTime male, DateTime female) {
    this.year_male = male.year;
    this.month_male = male.month;
    this.day_male = male.day;
    this.hour_male = male.hour;
    this.minute_male = male.minute;
    this.year_female = female.year;
    this.month_female = female.month;
    this.day_female = female.day;
    this.hour_female = female.hour;
    this.minute_female = female.minute;
  }
}
