// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:27
// usage ：自定义正则验证
// ------------------------------------------------------

class CusReg {
  // 验证手机号
  static bool phone(String phone) {
    return RegExp(
            r"^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[1,8,9]))\\d{8}\$")
        .hasMatch(phone);
  }

  // 纯数字
  static bool money(String money) {
    return RegExp(r"^[0-9]*$").hasMatch(money);
  }

  // 汉字
  static bool chinese(String char) {
    return RegExp(r"[\u4e00-\u9fa5]").hasMatch(char);
  }
}
