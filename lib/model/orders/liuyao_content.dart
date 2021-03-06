import 'package:yiapp/model/liuyaos/liuyao_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/25 上午10:01
// usage ：六爻 content 的内容
// ------------------------------------------------------

class LiuYaoContent {
  String yao_code; //  卦的代码
  // 这是公历表示的日期
  bool is_male;
  int year;
  int month;
  int day;
  int hour;
  int minute;
  // ------------------------ 自定义 ------------------------
  // 将测算的六爻结果也存储到Content中，方便显示，不需要根据 yao_code 再去六爻起卦
  LiuYaoResult liuyao_res;
  String qigua_time; // 起卦时间，不需要再根据年月日时分再次转换

  LiuYaoContent({
    this.yao_code,
    this.is_male,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.liuyao_res,
    this.qigua_time,
  });

  factory LiuYaoContent.fromJson(Map<String, dynamic> json) {
    return LiuYaoContent(
      yao_code: json['yao_code'],
      is_male: json['is_male'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      hour: json['hour'],
      minute: json['minute'],
      qigua_time: json['qigua_time'],
      liuyao_res: json['liuyao_res'] != null
          ? LiuYaoResult.fromJson(json['liuyao_res'])
          : null,
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
    data['qigua_time'] = this.qigua_time;
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
