import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/yiorder_exp_res.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 15:27
// usage : 商城订单相关及功能
// 涉及未完成订单表，历史表
// （完成订单，供查询，
//   未完成订单，用于交易）
// ------------------------------------------------------

class ApiYiOrder {
  static const String pre = "/yi/trade/";

  /// 已完成的订单--分页查询--适用于所有角色
  static yiOrderHisPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderHisPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  /// 大师未完成订单--分页查询--适用于前台下单人
  static yiOrderPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  /// 大师未完成订单--分页查询--适用于大师查询
  static yiOrderPageOfMaster(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderPageOfMaster";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  /// 大师未完成订单--分页查询--适用于后台管理员/客服使用
  static boYiOrderPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  /// 获取单条大师订单历史信息
  static Future<YiOrder> yiOrderHisGet(String id) async {
    var url = pre + "YiOrderHisGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return YiOrder.fromJson(m);
    }, enableJwt: true);
  }

  /// 获取单条大师处理中订单信息
  static Future<YiOrder> yiOrderGet(String id) async {
    var url = pre + "YiOrderGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return YiOrder.fromJson(m);
    }, enableJwt: true);
  }

  /// 大师订单-下单
  static Future<YiOrder> yiOrderAdd(Map<String, dynamic> m) async {
    var url = pre + "YiOrderAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return YiOrder.fromJson(m);
    }, enableJwt: true);
  }

  /// 完成订单结贴--用于大师操作
  static Future<bool> yiOrderComplete(String id) async {
    var url = pre + "YiOrderComplete";
    var data = {"id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  /// 大师操作--设置诊断结果
  static Future<bool> yiOrderSetDiagnose(Map<String, dynamic> m) async {
    var url = pre + "YiOrderSetDiagnose";
    return await ApiBase.postValue<bool>(url, m, enableJwt: true);
  }

  /// 用户操作--订单点评
  static Future<YiOrderExpRes> yiOrderExpAdd(Map<String, dynamic> data) async {
    var url = pre + "YiOrderExpAdd";
    return await ApiBase.postObj(url, data, (m) {
      return YiOrderExpRes.fromJson(m);
    }, enableJwt: true);
  }

  /// 获取大师订单点评
  static yiOrderExpPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderExpPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrderExpRes.fromJson(m));
  }

  /// 用户操作--投诉大师订单
  static Future<RefundRes> refundOrderAdd(Map<String, dynamic> data) async {
    var url = pre + "RefundOrderAdd";
    return await ApiBase.postObj(url, data, (m) {
      return RefundRes.fromJson(m);
    }, enableJwt: true);
  }
}
