// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午4:08
// usage ：合婚 content 的内容
// ------------------------------------------------------

import 'package:yiapp/model/sizhu/sizhu_result.dart';

class HeHunContent {
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
  // 自定义的
  String birth_date_male; // 男方出生日期
  String birth_date_female; // 女方出生日期
  SiZhuResult male_sizhu_res; // 男方八字
  SiZhuResult female_sizhu_res; // 女方八字

  HeHunContent({
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
    this.birth_date_male,
    this.birth_date_female,
    this.male_sizhu_res,
    this.female_sizhu_res,
  });

  factory HeHunContent.fromJson(Map<String, dynamic> json) {
    return HeHunContent(
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
      birth_date_male: json['birth_date_male'],
      birth_date_female: json['birth_date_female'],
      male_sizhu_res: json['male_sizhu_res'] != null
          ? SiZhuResult.fromJson(json['male_sizhu_res'])
          : null,
      female_sizhu_res: json['female_sizhu_res'] != null
          ? SiZhuResult.fromJson(json['female_sizhu_res'])
          : null,
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
    data['birth_date_male'] = this.birth_date_male;
    data['birth_date_female'] = this.birth_date_female;
    if (this.male_sizhu_res != null) {
      data['male_sizhu_res'] = this.male_sizhu_res.toJson();
    }
    if (this.female_sizhu_res != null) {
      data['female_sizhu_res'] = this.female_sizhu_res.toJson();
    }
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
