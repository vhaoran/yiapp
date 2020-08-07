import 'package:intl/intl.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:26
// usage ：转换时间格式、显示发送时间及间隔
// ------------------------------------------------------

/// 转换时间格式 2020-06-06 11:18:24 为指定时间格式
class CusTime {
  // 转换为年月日，如 2020年6月29日
  static String ymd(String createdAt) {
    var date = DateTime.parse(createdAt);
    String time = "${date.year}年${date.month}月${date.day}日";
    return time;
  }

  // 转换为时分，如 15:29
  static String hm(String createdAt) {
    var date = DateTime.parse(createdAt);
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return "${date.hour}:$minute";
  }

  // 转换为年月日时分，如 2020年8月6日10:37
  static String ymdhm(String createdAt) {
    var date = DateTime.parse(createdAt);
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return "${date.year}年${date.month}月${date.day}日${date.hour}:$minute";
  }
}


/// 显示发送时间及间隔
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
