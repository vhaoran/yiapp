// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:27
// usage ：自定义正则验证
// ------------------------------------------------------

import 'package:yiapp/complex/tools/regexp/regexp.dart';

class SuRegExp {
  /// 精准验证18位身份证号码
  static bool isIDCard18(String input) {
    return matches(Reg.IdCard, input);
  }

  /// 验证邮箱
  static bool isEmail(String input) {
    return matches(Reg.Email, input);
  }

  /// 验证 url
  static bool isURL(String input) {
    return matches(Reg.Url, input);
  }

  /// 验证汉字
  static bool isZh(String input) {
    return '〇' == input || matches(Reg.Zh, input);
  }

  /// 精准验证手机号
  static bool isMobile(String input) {
    return matches(Reg.mobile, input);
  }

  /// 验证电话号码
  static bool isTel(String input) {
    return matches(Reg.tel, input);
  }

  /// 验证 IP 地址
  static bool isIP(String input) {
    return matches(Reg.ip, input);
  }

  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }

  // 验证码个数
  static bool captcha(String captcha) {
    return RegExp(r"^\d{6}$").hasMatch(captcha);
  }

  // 纯数字
  static bool onlyNum(String money) {
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
}
