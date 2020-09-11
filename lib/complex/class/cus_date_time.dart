import 'package:yiapp/complex/class/old_time.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/11 17:09
// usage ：针对周易日历设置的数据格式
// ------------------------------------------------------

class CusDateTime {
  final int year;
  final int month;
  final int day;
  final int hourIndex; // 小时的下标，如 00:00-00:59早子 的下标是0
  final String hour; // 返回类如 早子、丑时
  final OldTime oldTime; // 根据hour 返回时分

  CusDateTime(
    this.year,
    this.month,
    this.day,
    this.hourIndex,
    this.hour,
  ) : this.oldTime = OldTime.from(hour);
}
