// ------------------------------------------------------
// author：suxing
// date  ：2020/9/17 18:25
// usage ：自定义日志类
// ------------------------------------------------------

class Log {
  /// 普通打印，绿色
  static info(String info) => print(">>>$info");

  /// 报错打印，黄色
  static error(String error) => print("<<<$error");
}

/// 临时便于打印
String logVie(bool isVie) {
  return isVie ? "闪断帖" : "悬赏帖";
}
