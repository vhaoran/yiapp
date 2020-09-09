import 'package:yiapp/model/orders/productOrder.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';

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
  // /yi/trade/ProductOrderPage
  static const String pre = "/yi/trade/";

  //------已完成的订单--分页查询--适用于所有角色-----
  static yiOrderHisPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderHisPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  //--w大师未完成订单--分页查询--适用于前台下单人查询------分页查询-----------
  static yiOrderPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  //--w大师未完成订单--分页查询--适用于大师查询------
  static yiOrderPageOfMaster(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderPageOfMaster";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  //--大师未完成订单--分页查询--适用于后台管理员/客服使用
  static boYiOrderPage(Map<String, dynamic> pb) async {
    var url = pre + "YiOrderPage";
    return await ApiBase.postPage(url, pb, (m) => YiOrder.fromJson(m));
  }

  //
  //--------w大师订单历史 --获取单条信息get-------------------
  static Future<YiOrder> yiOrderHisGet(String id) async {
    var url = pre + "YiOrderHisGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return YiOrder.fromJson(m);
    }, enableJwt: true);
  }

  //--------w大师未完成订单 --获取单条信息get-------------------
  static Future<YiOrder> yiOrderGet(String id) async {
    var url = pre + "YiOrderGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return YiOrder.fromJson(m);
    }, enableJwt: true);
  }

  //---------------------------
  static Future<YiOrder> yiOrderAdd(Map<String, dynamic> m) async {
    var url = pre + "YiOrderAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return YiOrder.fromJson(m);
    }, enableJwt: true);
  }

  static Future<bool> yiOrderComplete(String id) async {
    var url = pre + "YiOrderComplete";
    var data = {"id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
//------------------------------------------------
}