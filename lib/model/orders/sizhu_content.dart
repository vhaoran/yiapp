import 'package:yiapp/model/sizhu/sizhu_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 下午2:47
// usage ：四柱 content 的内容
// ------------------------------------------------------

class SiZhuContent {
  String name; // 姓名，没有输入的话按匿名处理
  bool is_solar;
  bool is_male;
  int year;
  int month;
  int day;
  int hour;
  int minute;
  // 自定义
  String birth_date;
  SiZhuResult sizhu_res;

  SiZhuContent({
    this.is_solar,
    this.name,
    this.is_male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.birth_date,
    this.sizhu_res,
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
      birth_date: json['birth_date'],
      sizhu_res: json['sizhu_res'] != null
          ? SiZhuResult.fromJson(json['sizhu_res'])
          : null,
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
    data['birth_date'] = this.birth_date;
    if (this.sizhu_res != null) {
      data['sizhu_res'] = this.sizhu_res.toJson();
    }
    return data;
  }

  /// 返回的时间数据转换为 DateTime
  DateTime toDateTime() {
    return DateTime(this.year, this.month, this.day, this.hour, this.minute);
  }
}
