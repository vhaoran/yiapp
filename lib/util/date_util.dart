import 'package:secret/secret.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/23 下午4:21
// usage ：Lunar 相关时间转换
// ------------------------------------------------------

class DateUtil {
  /// 根据阴阳历，转换相应的年月日
  static String dateYMD({bool isSolar, dynamic date}) {
    if (date is YiDateTime) {
      date = (date as YiDateTime).toDateTime();
    }
    if (isSolar) {
      return solarYMD(date); // 公历 2020年11月24日
    }
    return lunarYMD(date); // 农历 2020年十月初十
  }

  /// 阴历的年月日 2020年十月初十
  static String lunarYMD(DateTime date) {
    Solar solar = Solar.fromDate(date); // 2020-11-24
    Lunar lunar = solar.getLunar(); // 二〇二〇年十月初十
    String md = lunar.toString().substring(5); // 十月初十
    return "农历 ${solar.year}年$md";
  }

  /// 阳历的年月日 2020年11月24日
  static String solarYMD(DateTime date) {
    String month = "${date.month}".padLeft(2, "0") + "月";
    String day = "${date.day}".padLeft(2, "0") + "日";
    String res = "公历 ${date.year}年$month$day"; // 2020年11月24日
    return res;
  }

  /// 解析字符串时间格式为年月日，如 2020-11-24 16:28:02 → 2020年11月24日
  static String parseYMD(String created_at) {
    DateTime date = DateTime.parse(created_at);
    String res = "${date.year}年${date.month}月${date.day}日";
    return res;
  }
}
