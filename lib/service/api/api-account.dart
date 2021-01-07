// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 10:29
// usage : 支付与充值
//
// ------------------------------------------------------

import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/model/dicts/account.dart';
import 'package:yiapp/model/dicts/balance_res.dart';
import 'package:yiapp/model/dicts/master_balance_res.dart';
import 'package:yiapp/model/pays/bankcard_res.dart';
import 'package:yiapp/model/pays/business.dart';
import 'package:yiapp/model/pays/master_business_month.dart';
import 'package:yiapp/model/pays/master_business_res.dart';
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

  // 对账单历史--------分页查询
  static businessPage(Map<String, dynamic> pb) async {
    var url = "/yi/trade/BusinessPage";
    return await ApiBase.postPage(url, pb, (m) => Business.fromJson(m));
  }

  /// 获取个人余额
  static Future<BalanceRes> remainderGet() async {
    var url = "/yi/trade/RemainderGet";
    var data = {"uid": ApiBase.uid};
    return await ApiBase.postObj(url, data, (m) {
      return BalanceRes.fromJson(m);
    }, enableJwt: true);
  }

  /// 获取大师余额
  static Future<MasterBalanceRes> remainderMasterGet() async {
    var url = "/yi/trade/RemainderMasterGet";
    var data = {"master_id": ApiBase.uid};
    return await ApiBase.postObj(url, data, (m) {
      return MasterBalanceRes.fromJson(m);
    }, enableJwt: true);
  }

  /// x获取提现帐号get
  static Future<BankCardRes> bankCardInfoGet() async {
    var url = w_yi_trade + "BankCardInfoGet";
    var data = {"acc_type": "master", "m_or_b_id": ApiBase.uid};
    return await ApiBase.postObj(url, data, (m) => BankCardRes.fromJson(m));
  }

  /// x提现帐号设置（适用于运营商及大师）add
  static Future<bool> bankCardInfoAdd(Map<String, dynamic> data) async {
    var url = w_yi_trade + "BankCardInfoAdd";
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  /// x修改提现帐号，适用于管理员或平台、大师
  static Future<bool> bankCardInfoCh(Map<String, dynamic> data) async {
    var url = w_yi_trade + "BankCardInfoCh";
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  /// 大师对帐单-page
  static businessMasterPage(Map<String, dynamic> pb) async {
    var url = w_yi_trade + "BusinessMasterPage";
    return await ApiBase.postPage(
        url, pb, (m) => MasterBusinessRes.fromJson(m));
  }

  /// 大师月度对帐单-page
  static businessMasterMonthPage(Map<String, dynamic> pb) async {
    var url = w_yi_trade + "BusinessMasterMonthPage";
    return await ApiBase.postPage(url, pb, (m) => MasterMonthRes.fromJson(m));
  }
}
