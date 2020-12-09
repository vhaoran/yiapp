import 'package:secret/secret.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/23 下午4:21
// usage ：Lunar 相关时间转换
// ------------------------------------------------------

class TimeUtil {
  /// 根据阴阳历，转换相应的年月日，comment 是否显示文字"公历""农历"，默认不显示
  static String YMD({bool isSolar = true, bool comment = false, dynamic date}) {
    if (date == null) {
      date = DateTime.now();
    } else {
      if (date is YiDateTime) {
        date = (date as YiDateTime).toDateTime();
      }
    }
    if (isSolar) {
      //  2020年11月24日 或者 公历 2020年11月24日
      return solarYMD(date, comment);
    }
    // 2020年十月初十 或者 农历 2020年十月初十
    return lunarYMD(date, comment);
  }

  /// 公历的年月日 2020年11月24日，comment 是否显示文字"公历""农历"，默认不显示
  static String solarYMD(DateTime date, bool comment) {
    String start = comment ? "公历 " : "";
    String month = "${date.month}".padLeft(2, "0") + "月";
    String day = "${date.day}".padLeft(2, "0") + "日";
    String res = "$start${date.year}年$month$day"; // 2020年11月24日
    return res;
  }

  /// 农历的年月日 2020年十月初十
  static String lunarYMD(DateTime date, bool comment) {
    String start = comment ? "农历 " : "";
    if (date == null) date = DateTime.now();
    return "$start${date.year}年${lunarMD(date: date)}";
  }

  /// 农历的月日 十月初十
  static String lunarMD({DateTime date}) {
    // 二〇二〇年十月初十
    Lunar lunar = Solar.fromDate(date ?? DateTime.now()).getLunar();
    String md = lunar.toString().substring(5); // 十月初十
    return md;
  }

  /// 年干支 庚子
  static String ganZhi({DateTime date}) {
    var res = Lunar.fromDate(date ?? DateTime.now());
    return res.yearInGanZhiExact;
  }

  /// 解析字符串时间格式为年月日，如 2020-11-24 16:28:02 → 2020年11月24日
  static String parseYMD(String createdAt) {
    DateTime date = DateTime.parse(createdAt);
    String res = "${date.year}年${date.month}月${date.day}日";
    return res;
  }

  /// 年月日时分
  static String YMDHM(
      {bool isSolar = true, bool comment = false, dynamic date}) {
    String ymd = YMD(isSolar: isSolar, comment: comment, date: date);
    String hm = HM(hour: date.hour, minute: date.minute);
    return ymd + " " + hm; // 默认年月日和时分之间有空格
  }

  /// 时分 如 09:05
  static String HM({int hour, int minute}) {
    String h = "${hour.toString().padLeft(2, "0")}";
    String m = "${minute.toString().padLeft(2, "0")}";
    return "$h:$m";
  }
}
