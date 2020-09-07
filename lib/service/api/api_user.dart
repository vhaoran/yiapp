import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3
// usage : 用户管理中所有的restAPI封装
//
// ------------------------------------------------------

class ApiUser {
  /// 用户编码是否存在
  static Future<bool> userCodeExist(String userCode) async {
    var url = "/yi/user/UserCodeExist";
    var data = {"user_code": userCode};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  /// 用户手机号是否存在
  static Future<bool> MobileExist(String mobile) async {
    var url = "/yi/user/MobileExist";
    var data = {"mobile": mobile};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  /// 修改登录者本人信息
  static Future<bool> ChUserInfo(Map<String, dynamic> m) async {
    var url = "/user/ChUserInfo";
    var data = {"data": m};
    return await ApiBase.postValue<bool>(url, data);
  }

  /// 修改本人手机号码
  static Future<bool> ChMobile(String msg_code, String mobile) async {
    var url = "/user/ChMobile";
    var data = {"msg_code": msg_code, "new_mobile": mobile};
    return await ApiBase.postValue<bool>(url, data);
  }
}
