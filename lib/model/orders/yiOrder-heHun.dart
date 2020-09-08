// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 15:33
// usage : 大师订单内容--合婚使用
//
// ------------------------------------------------------
class YiOrderHeHun {
  //female :女方
  String name_female;

  //true 阳历 false:阴历
  bool is_solar_female;
  int year_female;
  int month_female;
  int day_female;
  int hour_female;
  int minute_female;

  //female :男方
  String name_male;

  //true 阳历 false:阴历
  bool is_solar_male;
  int year_male;
  int month_male;
  int day_male;
  int hour_male;
  int minute_male;

  YiOrderHeHun(
      {this.day_female,
      this.day_male,
      this.hour_female,
      this.hour_male,
      this.is_solar_female,
      this.is_solar_male,
      this.minute_female,
      this.minute_male,
      this.month_female,
      this.month_male,
      this.name_female,
      this.name_male,
      this.year_female,
      this.year_male});

  factory YiOrderHeHun.fromJson(Map<String, dynamic> json) {
    return YiOrderHeHun(
      day_female: json['day_female'],
      day_male: json['day_male'],
      hour_female: json['hour_female'],
      hour_male: json['hour_male'],
      is_solar_female: json['is_solar_female'],
      is_solar_male: json['is_solar_male'],
      minute_female: json['minute_female'],
      minute_male: json['minute_male'],
      month_female: json['month_female'],
      month_male: json['month_male'],
      name_female: json['name_female'],
      name_male: json['name_male'],
      year_female: json['year_female'],
      year_male: json['year_male'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_female'] = this.day_female;
    data['day_male'] = this.day_male;
    data['hour_female'] = this.hour_female;
    data['hour_male'] = this.hour_male;
    data['is_solar_female'] = this.is_solar_female;
    data['is_solar_male'] = this.is_solar_male;
    data['minute_female'] = this.minute_female;
    data['minute_male'] = this.minute_male;
    data['month_female'] = this.month_female;
    data['month_male'] = this.month_male;
    data['name_female'] = this.name_female;
    data['name_male'] = this.name_male;
    data['year_female'] = this.year_female;
    data['year_male'] = this.year_male;
    return data;
  }
}
