import 'package:yiapp/model/login/login_result.dart';

import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3
// usage : 用户登录相关的api,如图片验证码等
//
// ------------------------------------------------------

class ApiLogin {
//  static Future<CaptchaResult> CaptchaID() async {
//    var url = "/util/CaptchaID";
//    var data = {"id": 1};
//    return await ApiBase.postObj<CaptchaResult>(
//        url, data, (m) => CaptchaResult.fromJson(m),
//        enableJwt: false);
//  }

  static Future<bool> CaptchaVerify(String id, String code) async {
    var url = "/util/CaptchaVerify";
    var data = {"id": id, "Code": code};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  //传入获取到的图片名称，可以直接返回url地址
  static String CaptchaPath(String imageName) {
    String url = "http://${ApiBase.host}/util/$imageName";
    debug(url);
    return url;
  }

  //用户注册
  static Future<bool> RegUser(dynamic data) async {
    var url = "/user/RegUser";
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  //发送手机短信难码----仅在重置密码时使用
  static Future<bool> MobileCaptcha(String userCode) async {
    var url = "/user/MobileCaptcha";
    var data = {"user_code": userCode};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //重置密码
  static Future<bool> ResetPwd(dynamic data) async {
    var url = "/user/ResetPwd";
    //var data = {"user_code": userCode};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  // LoginResult
  //判断用户编码是否存在
  static Future<LoginResult> Login(Map<String, dynamic> data) async {
    var url = "/user/Login";
    //var data = {"uid": uid};
    return await ApiBase.postObj(url, data, (m) {
      return LoginResult.fromJson(m);
    }, enableJwt: false);
  }

  // LoginResult
  //判断用户编码是否存在
  static Future<LoginResult> WXLogin(String code) async {
    var url = "/user/WXLogin";
    var data = {"code": code};
    return await ApiBase.postObj(url, data, (m) {
      return LoginResult.fromJson(m);
    }, enableJwt: false);
  }

  static Future<bool> MobileCaptchaOfRegUser(String phone_number) async {
    var url = "/user/MobileCaptchaOfRegUser";
    var data = {
      "phone_number": phone_number,
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  static Future<bool> ChUserPwd(String old, String newPwd) async {
    var url = "/user/ChUserPwd";
    var data = {
      "old_pwd": old,
      "new_pwd": newPwd,
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
}
