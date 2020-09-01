// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 18:57
// usage ：数学运算工具
// ------------------------------------------------------

import 'dart:math';

class CusMath {
  /// 根据当前时间的毫秒数，随机生成该数，并取相应的模
  static int random({int mod = 100}) {
    int res = DateTime.now().millisecond % mod;
    if (res == 0) {
      Random r = Random();
      res = r.nextInt(mod);
    }
    return res;
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
