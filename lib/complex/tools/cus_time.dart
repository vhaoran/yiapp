import 'package:intl/intl.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/func/const/const_list.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:26
// usage ：转换时间格式、显示发送时间及间隔
// ------------------------------------------------------

/// 转换时间格式 2020-06-06 11:18:24 为指定时间格式
class CusTime {
  static String _padLeft(String str) {
    if (str == null) return "_padLeft 传值为空";
    return str.padLeft(2, "0");
  }

  /// 获取每个月的天数
  static int dayInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// 转换为年月日，如 2020年6月29日
  static String ymd(String createdAt) {
    var date = DateTime.parse(createdAt);
    String time = "${date.year}年${date.month}月${date.day}日";
    return time;
  }

  /// 横杠日期 如 转换 2020年08月19日 为 2020-08-19
  static String ymdBar(String createdAt) {
    var date = DateTime.parse(createdAt);
    String mouth = "${_zero(date.month)}-";
    String day = "${_zero(date.day)}";
    String time = "${date.year}-$mouth$day";
    return time;
  }

  /// 转换为时分，如 15:29
  static String hm(String createdAt) {
    var date = DateTime.parse(createdAt);
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return "${date.hour}:$minute";
  }

  /// 转换为年月日时分，如 2020年8月6日10:37
  static String ymdhm(String createdAt) {
    if (createdAt == null) return "2020年01月01日00:00";
    var date = DateTime.parse(createdAt);
    String month = _padLeft("${date.month}");
    String day = _padLeft("${date.day}");
    String hour = _padLeft("${date.hour}");
    String minute = _padLeft("${date.minute}");
    return "${date.year}年$month月$day日 $hour:$minute";
  }

  /// 根据传入的年份显示天干地支 如 庚子
  static String zodiac(int year) {
    int day = (year - 3) % 10; // 天干
    int earth = (year - 3) % 12; // 地支
    String dayStr = c_day_stem[day];
    String earthStr = c_earth_branch[earth];
    return dayStr + earthStr;
  }

  /// 大写、小写的月日，如大写 六月廿四，小写 六月二十四
  static String capitalMd({DateTime dateTime, bool lower = false}) {
    var date = Lunar.fromDate(dateTime ?? DateTime.now());
    String month = date.monthInChinese;
    String day = date.dayInChinese;
    if (lower) {
      day = day.contains("廿") ? day.replaceFirst("廿", "二十") : day;
    }
    String str = month + "月" + day;
    return str;
  }

  /// 干支年+大写的月日 如 庚子年六月二十四
  static String dayEarthMd({DateTime dateTime, bool lower = false}) {
    var date = Lunar.fromDate(dateTime ?? DateTime.now());
    String str = zodiac(date.year) + "年" + capitalMd(lower: lower);
    return str;
  }

  /// 小于10的月日前面补0 可以用 num.padLeft(2,"0")代替，不足两位补0
  static String _zero(int value) {
    String str = value < 10 ? "0$value" : "$value";
    return str;
  }

  /// 如果指定了 start end ，这两项来决定在 start 之前和 end 之后的时间不在显示
  static bool isRange(DateTime date, DateTime start, DateTime end) {
    if (start == null && end == null) return true;
    // isAtSameMomentAs 同传入的DateTime进行比较，如果二者表示的时间在同一时刻，则返回true
    if (start == null && end != null) {
      // isBefore 同传入的DateTime进行比较，如果标识的时间在传入实例之前，则返回true
      return date.isBefore(end) || date.isAtSameMomentAs(end);
    }
    if (start != null && end == null) {
      // 同传入的DateTime进行比较，如果标识的时间在传入实例之后，则返回true
      return date.isAfter(start) || date.isAtSameMomentAs(start);
    }
    return (date.isAfter(start) && date.isBefore(end)) ||
        date.isAtSameMomentAs(start) ||
        date.isAtSameMomentAs(end);
  }
}

/// 显示发送时间及间隔[]
class UtilTime {
  static List<int> dateD(DateTime date, DateTime date2) {
    Duration di = date.difference(date2);
    return [di.inDays, di.inHours, di.inMinutes, di.inSeconds];
  }

  /// howLong([DateTime.parse('2018-10-10 09:30:36')])
  static howLong(DateTime date, {DateTime date2}) {
    List<String> sl = ['天', '小时', '分钟', '刚刚'];
    List<int> dl = dateD(date2 ?? new DateTime.now(), date);
    for (var i = 0; i < dl.length; i++)
      if (dl[i] != 0) return i != 3 ? '${dl[i]}${sl[i]}前' : sl[i];
    return '刚刚';
  }

  /// difDate([DateTime.parse('2018-10-10 09:30:36')])
  static String difDate(DateTime date, DateTime date2) {
    if (date2 == null) return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
    List<int> dn = dateD(new DateTime.now(), date);
    List<int> di = dateD(date, date2);
    if (dn[0] > 0 || di[0] > 0) {
      if (di[2] > 2) return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
      return '';
    } else {
      if (di[2] > 2) return DateFormat('HH:mm:ss').format(date);
      return '';
    }
  }
}
