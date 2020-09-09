// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 10:29
// usage : 支付与充值
//
// ------------------------------------------------------

import 'package:yiapp/model/dicts/account.dart';
import 'package:yiapp/model/pays/business.dart';

import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 10:15
// usage : 支付帐号及对帐单
//
// ------------------------------------------------------
class ApiAccount {
  //设置用户支付帐号，新增或修改均用此方法
  static Future<Account> accountSet(Map<String, dynamic> m) async {
    var url = "/yi/trade/AccountSet";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return Account.fromJson(m);
    }, enableJwt: true);
  }

  //设置默认帐户,
  //帐号类型    0：支付宝 1：微信
  static Future<bool> accountSetDefault(int accountType) async {
    var url = "/yi/trade/AccountSetDefault";
    var data = {"account_type": accountType};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //个人支付帐号-删除
  //帐号类型    0：支付宝 1：微信
  static Future<bool> accountRm(int accountType) async {
    var url = "/yi/trade/AccountRm";
    var data = {"account_type": accountType};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //w个人支付帐号-列表查询
  static Future<List<Account>> accountList() async {
    var url = "/yi/trade/AccountList";
    var data = new Map<String, dynamic>();

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => Account.fromJson(e)).toList();
    }, enableJwt: true);
  }

//------------------------------------------------
  //通讯录--------分页查询
  static businessPage(Map<String, dynamic> pb) async {
    var url = "/yi/trade/BusinessPage";
    return await ApiBase.postPage(url, pb, (m) => Business.fromJson(m));
  }
}
