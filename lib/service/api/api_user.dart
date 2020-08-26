import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/3
// usage : 用户管理中所有的restAPI封装
//
// ------------------------------------------------------
class ApiUser {
  //判断用户编码是否存在
  static Future<bool> userCodeExist(String userCode) async {
    var url = "/user/UserCodeExist";
    var data = {"user_code": userCode};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  //用户手机号是否存在
  static Future<bool> MobileExist(String mobile) async {
    var url = "/user/MobileExist";
    var data = {"mobile": mobile};
    return await ApiBase.postValue<bool>(url, data, enableJwt: false);
  }

  //判断用户编码是否存在
//  static Future<UserInfoPublic> GetUserPublic(int uid) async {
//    var url = "/user/GetUserPublic";
//    var data = {"uid": uid};
//    return await ApiBase.postObj(url, data, (m) {
//      return UserInfoPublic.fromJson(m);
//    }, enableJwt: false);
//  }

  //获取用户个人信息，仅限于登录者本人
//  static Future<UserInfo> GetUser() async {
//    var url = "/user/GetUser";
//    var data = {"a": "no-data"};
//    return await ApiBase.postObj(url, data, (m) {
//      return UserInfo.fromJson(m);
//    }, enableJwt: true);
//  }

  //修改登录者本从的其它信息，uid,mobile,user_code不能修改，
  // ignore: non_constant_identifier_names
  static Future<bool> ChUserInfo(Map<String, dynamic> m) async {
    var url = "/user/ChUserInfo";
    var data = {"data": m};
    return await ApiBase.postValue<bool>(url, data);
  }

  static Future<bool> ChUserIcon(String iconPath) async {
    var url = "/user/ChUserIcon";
    var data = {"icon": iconPath};
    return await ApiBase.postValue<bool>(url, data);
  }

  //通讯录--------分页查询
  // action: 0:所有  1：好友 2：群
//  static AddrPage(Map<String, dynamic> pb, {int action = 0}) async {
//    var url = "/user/AddrPage";
//    pb["action"] = action;
//    return await ApiBase.postPage<Addr>(url, pb, (m) => Addr.fromJson(m));
//  }

  //添加到通讯录
  static Future<bool> ToAddrList(Map<String, dynamic> m) async {
    var url = "/user/ToAddrList";
    var data = m;
    return await ApiBase.postValue<bool>(url, data);
  }

  //黑名单列表
//  static Future<List<BlackList>> ListBlackList() async {
//    var url = "/user/ListBlackList";
//    var data = {"x": 1};
//    return await ApiBase.postList(url, data, (l) {
//      return l.map((x) => BlackList.fromMap(x)).toList();
//    });
//  }

  //添加到黑名单
  static Future<bool> ToBlackList(int uid) async {
    var url = "/user/ToBlackList";
    var data = {"uid": uid};
    return await ApiBase.postValue<bool>(url, data);
  }

  //多黑名单中移除某人
  static Future<bool> RmBlackList(int uid) async {
    var url = "/user/RmBlackList";
    var data = {"uid": uid};
    return await ApiBase.postValue<bool>(url, data);
  }

  //修改本人手机号码
  static Future<bool> ChMobile(String msg_code, String mobile) async {
    var url = "/user/ChMobile";
    var data = {
      "msg_code": msg_code,
      "new_mobile": mobile,
    };
    return await ApiBase.postValue<bool>(url, data);
  }

//----------class end--------------------------------------
}
