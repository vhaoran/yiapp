import 'package:secret/tools/lunar.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/old_time.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/11 17:09
// usage ：针对周易日历设置的数据格式
// ------------------------------------------------------

class YiDateTime {
  // 下面五个数据和 oldTime 用来传递给后台
  final int year;
  final int month;
  final int day;
  final int hour; // 小时的下标，如 00:00-00:59早子 的下标是0
  final int minute;
  // 下面带 Str 的是为了前端显示使用
  final String monthStr; // 返回月份，如8月，闰五月
  final String dayStr; // 返回日数，如11日，廿五
  final String hourStr; // 返回时辰，如 早子、丑时
  final OldTime oldTime; // 根据hour 返回时分

  YiDateTime({
    this.year: 0,
    this.month: 0,
    this.day: 0,
    this.hour: 0,
    this.minute: 0,
    this.monthStr,
    this.dayStr,
    this.hourStr,
  }) : this.oldTime = OldTime.from(hourStr);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['year'] = this.year;
    data['month'] = this.month;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['monthStr'] = this.monthStr;
    data['dayStr'] = this.dayStr;
    data['hourStr'] = this.hourStr;
    if (this.oldTime != null) {
      data['oldTime'] = this.oldTime.toJson();
    }
    return data;
  }

  /// YiDateTime 转 DateTime
  DateTime toDateTime() {
    var dt = DateTime(this.year, this.month, this.day, this.hour, this.minute);
    return dt;
  }

  YiDateTime fromDateTime(DateTime dt) {
    return YiDateTime(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
    );
  }

  /// YiDateTime转阳历，选择阴历后得到阴历日期，调用TimeUtil后会判断其为阴历再次转换
  /// 所以如果选择的是阴历，则先将阴历转为阳历显示
  DateTime toSolar() {
    Lunar lunar = Lunar.fromYmd(this.year, this.month, this.day);
    Log.info("lunar：${lunar.toString()}");
    var t = lunar.toSolar;
    Log.info("lunar.toSolar：${t.toString()}");
    DateTime dt = DateTime(t.year, t.month, t.day, this.hour, this.minute);
    return dt;
  }
}
