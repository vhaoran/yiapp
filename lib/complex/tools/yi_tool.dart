import 'dart:math';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_int.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/2 19:13
// usage ：周易相关的工具
// ------------------------------------------------------

class YiTool {
  /// 返回抽签数
  static int draw({int mod = 100}) {
    int res = DateTime.now().microsecond % mod;
    if (res == 0) {
      Random r = Random();
      res = r.nextInt(mod);
    }
    return res;
  }

  // 返回类如 公历 2020年09月03日 14：08
  static String fullDateGong(YiDateTime date) {
    String month = "${date.month}".padLeft(2, "0");
    String day = "${date.day}".padLeft(2, "0");
    String hour = "${date.hour}".padLeft(2, "0");
    String minute = "${date.minute}".padLeft(2, "0");
    return "公历 ${date.year}年$month月$day日 $hour:$minute";
  }

  // 返回类如 农历 2020年七月廿五 子时
  static String fullDateNong(YiDateTime date) {
    String monthDay = "${date.monthStr}${date.dayStr}";
    String hour = "${date.hour}".padLeft(2, "0");
    String minute = "${date.minute}".padLeft(2, "0");
    return "农历 ${date.year}年$monthDay $hour:$minute";
  }

  /// 转换格式为类如 2020-09-11
  static String ymdBar(dynamic date) {
    String month = "${date.month}".padLeft(2, "0");
    String day = "${date.day}".padLeft(2, "0");
    return "${date.year}-$month-$day";
  }

  /// 将 YiDateTime 转为 DateTime
  static DateTime toDateTime(YiDateTime cdt) {
    DateTime dt = DateTime(cdt.year, cdt.month, cdt.day);
    return dt;
  }

  static YiDateTime toYiDate(DateTime date) {
    YiDateTime yiDate = YiDateTime(
      year: date.year,
      month: date.month,
      day: date.day,
      hour: date.hour,
      minute: date.minute,
    );
    return yiDate;
  }

  /// 符号，老阴、老阳显示 X 和 O，少阴少阳不显示
  static String xoSymbol(int code) {
    String str;
    switch (code) {
      case lao_yin: // 老阴
        str = "X";
        break;
      case lao_yang: // 老阳
        str = "O";
        break;
      default:
        str = "";
        break;
    }
    return str;
  }

  /// 根据数字，转换为对应的中文，如 79 to 七十九，支持三位数以内的
  static String numToChinese(int num) {
    String numStr = "0123456789";
    String charStr = "零一二三四五六七八九";
    var l = num.toString().split('');
    String tmp = "";
    for (var i = 0; i < l.length; i++) {
      int index = numStr.indexOf(l[i]);
      if (index != -1) {
        tmp += charStr.split('')[index];
      }
    }
    var res = tmp.split('');
    // 单位数
    if (res.length == 1)
      return tmp;
    // 两位数
    else if (res.length == 2) {
      if (res.first == "一") {
        res.first = "";
      }
      if (res.last == "零") {
        res.last = "";
      }
      return "${res.first}十${res[1]}";
    }
    // 三位数
    else if (res.length == 3) {
      if (res[1] != "零") {
        res[1] += "十";
      }
      if (res[1] == "零" && res.last == "零") {
        res[1] = res.last = "";
      }
      if (res.last == "零") {
        res.last = "";
      }
      return "${res.first}百${res[1]}${res.last}";
    }
    return "最多支持三位数";
  }
}
