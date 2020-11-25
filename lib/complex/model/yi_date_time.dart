import 'package:yiapp/complex/model/old_time.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';

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
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
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

  // YiDateTime 转 DateTime
  DateTime toDateTime() {
    int year = this.year;
    int month = this.month;
    int day = this.day;
    int hour = this.hour;
    int minute = this.minute;
    DateTime dt = DateTime(year, month, day, hour, minute);
    return dt;
  }

  String yiTimeShow(YiDateTime t, bool isLunar) {
    if (t != null) {
      if (isLunar) {
        return "${t.year}年${t.monthStr}${t.dayStr} ${t.hourStr}";
      }
      return "${t.year}-${t.month}-${t.day}- ${t.hourStr}";
    }
    return "转换YiDateTime为字符串出错";
  }

  /// 根据 PickMode 给不同的数据，方便看实际需求参数
  /// 也可不用判断，只是看数据比较乱
  YiDateTime fromPickMode(PickerMode mode) {
    YiDateTime yiDate;
    switch (mode) {
      case PickerMode.year: // 年
        yiDate = YiDateTime(year: this.year);
        break;
      case PickerMode.year_month: // 年月
        yiDate = YiDateTime(
          year: this.year,
          month: this.month,
          monthStr: this.monthStr,
        );
        break;
      case PickerMode.month_day: // 月日
        yiDate = YiDateTime(
          month: this.month,
          day: this.day,
          monthStr: this.monthStr,
          dayStr: this.dayStr,
        );
        break;
      case PickerMode.date: // 年月日
        yiDate = YiDateTime(
          year: this.year,
          month: this.month,
          day: this.day,
          monthStr: this.monthStr,
          dayStr: this.dayStr,
        );
        break;
      case PickerMode.hour_minute: // 时分
        yiDate = YiDateTime(hour: this.hour, minute: this.minute);
        break;
      case PickerMode.full: // 年月日时分
        yiDate = YiDateTime(
          year: this.year,
          month: this.month,
          day: this.day,
          hour: this.hour,
          minute: this.minute,
          monthStr: this.monthStr,
          dayStr: this.dayStr,
          hourStr: this.hourStr,
        );
        break;
      case PickerMode.yi:
        yiDate = YiDateTime(
          year: this.year,
          month: this.month,
          day: this.day,
          monthStr: this.monthStr,
          dayStr: this.dayStr,
          hourStr: this.hourStr,
        );
        break;
      default:
        break;
    }
    return yiDate;
  }

  /// 返回格式  公历:2020-09-10 午时
  String gongLi({String text = "公历"}) {
    String month = "${this.month}".padLeft(2, "0");
    String day = "${this.day}".padLeft(2, "0");
    return "$text:${this.year}-$month-$day ${this.hourStr}";
  }

  /// 返回格式  阴历:2020年四月廿九 午时
  String nongLi({String text = "农历"}) {
    String year = "${this.year}年"; // 2020
    // 四月廿九
    String monthDay = "${this.monthStr}${this.dayStr}";
    String oldTime = "${this.hourStr}"; // 午时
    String str = "$text:$year$monthDay $oldTime";
    return str;
  }
}
