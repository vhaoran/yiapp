// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:27
// usage ：自定义正则验证
// ------------------------------------------------------

class CusRegExp {
  // 验证手机号
  static bool phone(String phone) {
    return RegExp(
            "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$")
        .hasMatch(phone);
  }

  // 验证码个数
  static bool captcha(String captcha) {
    return RegExp(r"^\d{6}$").hasMatch(captcha);
  }

  // 纯数字
  static bool retainNum(String money) {
    return RegExp(r"^[0-9]*$").hasMatch(money);
  }

  // 大小写字母
  static bool upLower(String str) {
    return RegExp(r"^[A-Za-z]+$").hasMatch(str);
  }

  // 大写字母
  static bool upChar(String str) {
    return RegExp("^[A-Z]").hasMatch(str);
  }

  // 小写字母
  static bool lowerChar(String str) {
    return RegExp("^[a-z]").hasMatch(str);
  }

  // 汉字
  static bool chinese(String char) {
    return RegExp(r"[\u4e00-\u9fa5]").hasMatch(char);
  }
}
