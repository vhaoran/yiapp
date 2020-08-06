// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:26
// usage ：转换时间格式
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
