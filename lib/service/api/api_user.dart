import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/model/login/userInfo.dart';

import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3
// usage : 用户管理中所有的restAPI封装
//
// ------------------------------------------------------

class ApiUser {
  /// 修改登录者本人信息
  static Future<bool> ChUserInfo(Map<String, dynamic> m) async {
    var url = "/yi/user/ChUserInfo";
    var data = {"data": m};
    return await ApiBase.postValue<bool>(url, data);
  }

  /// 修改用户密码
  static Future<bool> chUserPwd(String old_pwd, new_pwd) async {
    var url = "/yi/user/ChUserPwd";
    var data = {"old_pwd": old_pwd, "new_pwd": new_pwd};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  /// 获取用户信息
  static Future<UserInfo> getUser(Map<String, dynamic> m) async {
    var url = "/yi/user/GetUser";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => UserInfo.fromJson(m));
  }

  /// 获取用户公开信息(id, nick, icon, user_code, user_name是准确数据，其它为默认)
  static Future<UserInfo> getUserPublic(Map<String, dynamic> m) async {
    var url = "/yi/user/GetUserPublic";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => UserInfo.fromJson(m));
  }

  /// 添加收件地址
  static Future<AddressResult> userAddrAdd(Map<String, dynamic> m) async {
    var url = "/yi/user/UserAddrAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => AddressResult.fromJson(m));
  }

  /// 修改收货地址
  static Future<bool> userAddrCh(Map<String, dynamic> m) async {
    var url = "/yi/user/UserAddrCh";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  /// 获取地址列表
  static Future<List<AddressResult>> userAddrList(int uid) async {
    var url = "/yi/user/UserAddrList";
    var data = {"uid": uid};
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => AddressResult.fromJson(x)).toList());
  }

  /// 获取默认收件地址
  static Future<AddressResult> userAddrGetDefault(
      Map<String, dynamic> m) async {
    var url = "/yi/user/UserAddrGetDefault";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => AddressResult.fromJson(m));
  }

  /// 用户编码是否存在
  static Future<bool> userCodeExist(String userCode) async {
    var url = "/yi/user/UserCodeExist";
    var data = {"user_code": userCode};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  /// 删除收件地址
  static Future<bool> userAddrRm(Map<String, dynamic> m) async {
    var url = "/yi/user/UserAddrRm";
    var data = m;
    return await ApiBase.postValue<bool>(url, data);
  }

  /// 设置默认收件地址
  static Future<bool> userAddrSetDefault(Map<String, dynamic> m) async {
    var url = "/yi/user/UserAddrSetDefault";
    var data = m;
    return await ApiBase.postValue<bool>(url, data);
  }
}
