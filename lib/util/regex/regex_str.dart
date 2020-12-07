// ------------------------------------------------------
// author：suxing
// date  ：2020/11/30 下午7:06
// usage ：正则表达式
// ------------------------------------------------------

class RegexStr {
  /// 精准验证手机号
  static final String mobile =
      "^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,2,3,5-8])|(18[0-9])|(19[1,8,9]))\\d{8}\$";

  /// 验证电话号码
  static final String tel = "^0\\d{2,3}[- ]?\\d{7,8}";

  /// 精准验证18位身d份证号码
  static final String idCard =
      "^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])\$";

  /// 验证邮箱
  static final String email =
      "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  /// 验证 url
  static final String url = "[a-zA-Z]+://[^\\s]*";

  /// 验证汉字
  static final String zh = "[\\u4e00-\\u9fa5]";

  /// 验证 IP 地址
  static final String ip =
      "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";

  /// 验证纯数字
  static final String onlyNum = r"^[0-9]*$";

  /// 验证大小写字母
  static final String upLowerChar = r"^[A-Za-z]+$";

  /// 验证大写字母
  static final String upChar = "^[A-Z]";

  /// 验证小写字母
  static final String lowerChar = "^[a-z]";

  /// 验证码
  static final String captcha = r"^\d{6}$";
}
