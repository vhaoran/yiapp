// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 10:16
// usage : 代理 申请及审批，查询，管理员添加
//
// ------------------------------------------------------
import 'package:yiapp/model/dicts/broker-admin.dart';
import 'package:yiapp/model/dicts/broker-admin.dart';
import 'package:yiapp/model/dicts/broker-apply.dart';
import 'package:yiapp/model/dicts/broker-info.dart';
import 'package:yiapp/model/login/userInfo.dart';

import 'api_base.dart';

class ApiBroker {
  static const String pre = "/yi/user/";

  //-----代理信彷---分页查询--适用于管理员使用
  static brokerInfoPage(Map<String, dynamic> pb) async {
    var url = pre + "BrokerInfoPage";
    return await ApiBase.postPage(url, pb, (m) => BrokerInfo.fromJson(m));
  }

  //-------w新增代理管理员--------------------
  static Future<BrokerAdmin> brokerAdminAdd(Map<String, dynamic> m) async {
    var url = pre + "BrokerAdminAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return BrokerAdmin.fromJson(m);
    }, enableJwt: true);
  }

  //------当前登录admin用户 -列表查询-管理员-------------
  static Future<List<BrokerAdmin>> brokerAdminList() async {
    var url = pre + "BrokerAdminList";
    var data = {
      "comment": "此次测试不需要有任何参数的输入",
      "comment2": "Jwt必须要有",
      "comment3": "获取的这个列表是该uid所对用的broker_id的代理管理员",
    };

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => BrokerAdmin.fromJson(e)).toList();
    }, enableJwt: true);
  }

  static Future<bool> brokerAdminRm(int uid) async {
    var url = pre + "BrokerAdminRm";
    var data = {"uid": uid};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //---申请成为代理，------------------------
  static Future<BrokerApply> brokerApplyHandIn(Map<String, dynamic> m) async {
    var url = pre + "BrokerApplyHandIn";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return BrokerApply.fromJson(m);
    }, enableJwt: true);
  }

  //---------代理申请审批  管理员权限---------------------------------------
  //stat 2:驳回 1 通过
  static Future<bool> brokerApplyAudit(int id, int stat) async {
    var url = pre + "BrokerApplyAudit";
    var data = {
      "id": id,
      "stat": stat,
      "comment2": "Jwt必须要有, 大于0 即可",
      "comment3": "stat为1代表是通过申请, 2是驳回申请",
      "comment4": "审核通过后该用户成为代理,uid即owner_id, 拥有添加管理员的权限"
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //--代理申请------分页查询------适用于后台管理员--
  static brokerApplyPage(Map<String, dynamic> pb) async {
    var url = pre + "BrokerApplyPage";
    return await ApiBase.postPage(url, pb, (m) => BrokerApply.fromJson(m));
  }

  //----------w根据服务代码获取代理id--------------------------------------
  static Future<int> brokerIDGet(String serviceCode) async {
    var url = pre + "BrokerIDGet";
    var data = {"service_code": serviceCode};
    return await ApiBase.postValue<int>(url, data, enableJwt: true);
  }

  //---------------------------
  static Future<BrokerInfo> brokerInfoGet(int brokerID) async {
    var url = pre + "BrokerInfoGet";
    var data = {"broker_id": brokerID};
    return await ApiBase.postObj(url, data, (m) {
      return BrokerInfo.fromJson(m);
    }, enableJwt: true);
  }

  static Future<bool> serviceCodeBind(String service_code) async {
    var url = pre + "ServiceCodeBind";
    var data = {"service_code": service_code};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //----//--------搜索代理下的用户（按nick模糊或user_code精确查找）-------------
  static Future<List<UserInfo>> brokerUserInfoSearch(String keyword) async {
    var url = pre + "BrokerUserInfoSearch";
    var data = {
      "keyword": keyword,
      "comment": "keyword可以使user_code即手机号,也可以是nick的一部分",
      "comment2": "这个搜索可以理解为对user_code的精准匹配或对nick的模糊查询",
    };

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => UserInfo.fromJson(e)).toList();
    }, enableJwt: true);
  }

  //--------分页查询
  static brokerUserInfoPage(Map<String, dynamic> pb) async {
    var url = pre + "BrokerUserInfoPage";
    return await ApiBase.postPage(url, pb, (m) => UserInfo.fromJson(m));
  }

//------------------------------------------------

}
