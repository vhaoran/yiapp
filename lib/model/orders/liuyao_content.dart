import 'package:yiapp/model/liuyaos/liuyao_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/25 上午10:01
// usage ：六爻 content 的内容
// ------------------------------------------------------

class LiuYaoContent {
  String yao_code; //  卦的代码
  // 这是公历表示的日期
  bool male;
  int year;
  int month;
  int day;
  int hour;
  int minute;
  LiuYaoResult liuyao_res;

  LiuYaoContent({
    this.yao_code,
    this.male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.liuyao_res,
  });

  factory LiuYaoContent.fromJson(Map<String, dynamic> json) {
    return LiuYaoContent(
      yao_code: json['yao_code'],
      male: json['male'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      liuyao_res: json['liu_yao'] != null
          ? LiuYaoResult.fromJson(json['liu_yao'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['yao_code'] = this.yao_code;
    data['male'] = this.male;
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    if (this.liuyao_res != null) {
      data['liuyao_res'] = this.liuyao_res.toJson();
    }
    return data;
  }

  /// 返回的时间数据转换为 DateTime
  DateTime dateTime() {
    return DateTime(this.year, this.month, this.day, this.hour, this.minute);
  }
}
