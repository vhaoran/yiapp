// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:27
// usage ：自定义正则验证
// ------------------------------------------------------

class CusReg {
  // 验证手机号
  static bool phone(String phone) {
    return RegExp(r"1[0-9]\d{9}$").hasMatch(phone);
  }

  // 纯数字
  static bool money(String money) {
    return RegExp(r"^[0-9]*$").hasMatch(money);
  }
}
