import 'package:yiapp/util/regex/regex_str.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:27
// usage ：正则表达式函数
// ------------------------------------------------------

class RegexUtil {
  /// 精准验证手机号
  static bool isMobile(String input) {
    return matches(RegexStr.mobile, input);
  }

  /// 验证电话号码
  static bool isTel(String input) {
    return matches(RegexStr.tel, input);
  }

  /// 精准验证18位身份证号码
  static bool isIdCard(String input) {
    return matches(RegexStr.idCard, input);
  }

  /// 验证邮箱
  static bool isEmail(String input) {
    return matches(RegexStr.email, input);
  }

  /// 验证 url
  static bool isUrl(String input) {
    return matches(RegexStr.url, input);
  }

  /// 验证汉字
  static bool isZh(String input) {
    return '〇' == input || matches(RegexStr.zh, input);
  }

  /// 验证 IP 地址
  static bool isIP(String input) {
    return matches(RegexStr.ip, input);
  }

  // 验证纯数字
  static bool onlyNum(String input) {
    return RegExp(RegexStr.onlyNum).hasMatch(input);
  }

  // 验证大小写字母
  static bool upLowerChar(String input) {
    return RegExp(RegexStr.upLowerChar).hasMatch(input);
  }

  // 验证大写字母
  static bool upChar(String str) {
    return RegExp("^[A-Z]").hasMatch(str);
  }

  // 验证小写字母
  static bool lowerChar(String str) {
    return RegExp("^[a-z]").hasMatch(str);
  }

  // 验证码
  static bool captcha(String captcha) {
    return RegExp(r"^\d{6}$").hasMatch(captcha);
  }

  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return RegExp(regex).hasMatch(input);
  }
}
