import 'package:yiapp/model/login/login_result.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3
// usage : 用户登录相关的api,如图片验证码等
//
// ------------------------------------------------------

class ApiLogin {
  /// 用户注册
  static Future<bool> regUser(dynamic data) async {
    var url = "/yi/user/RegUser";
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  /// 用户登录
  static Future<LoginResult> login(Map<String, dynamic> data) async {
    var url = "/yi/user/Login";
    return await ApiBase.postObj(url, data, (m) => LoginResult.fromJson(m),
        enableJwt: false);
  }

  /// 游客登录
  static Future<LoginResult> guestLogin() async {
    var url = "/yi/user/GuestLogin";
    var data = {};
    return await ApiBase.postObj(url, data, (m) => LoginResult.fromJson(m),
        enableJwt: false);
  }
}
