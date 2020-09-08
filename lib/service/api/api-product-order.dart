import 'package:yiapp/model/orders/productOrder.dart';

import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 15:27
// usage : 商城订单相关及功能
//
// ------------------------------------------------------
class ApiProductOrder {
  // /yi/trade/ProductOrderPage
  static const String pre = "/yi/trade/";

  //-------有如此多的分页是因为不同的角色需要调用不同的功能
  //订音分页查询---适用于下单人（用户）--------分页查询
  static productOrderPage(Map<String, dynamic> pb) async {
    String url = pre + "ProductOrderPage";
    return await ApiBase.postPage(url, pb, (m) => ProductOrder.fromJson(m));
  }

  //----w商城待发货订单--分页查询--适用于后台发货时使用v----
  static bOProductOrderPage(Map<String, dynamic> pb) async {
    var url = pre + "BOProductOrderPage";
    return await ApiBase.postPage(url, pb, (m) => ProductOrder.fromJson(m));
  }

  //-----w已完成商城订单-分页查询-----适用于任何角色-------
  static productOrderHisPage(Map<String, dynamic> pb) async {
    var url = pre + "ProductOrderHisPage";
    return await ApiBase.postPage(url, pb, (m) => ProductOrder.fromJson(m));
  }

  //------w商城订单-下单---------------------
  static Future<ProductOrder> productOrderAdd(Map<String, dynamic> m) async {
    var url = pre + "ProductOrderAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return ProductOrder.fromJson(m);
    }, enableJwt: true);
  }

  //--------发货--必须是管理员权限 --tradeNo:发货单事情------------------------------------
  static Future<bool> productOrderDelivery(
      String orderID, String tradeNo) async {
    var url = pre + "ProductOrderDelivery";
    var data = {
      "id": orderID, //订单id
      "bill_no": tradeNo, //发货单号
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----确认收货必须 是本人-------------------------------------------
  static Future<bool> productOrderReceive(String id) async {
    var url = pre + "ProductOrderReceive";
    var data = {"id": id};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //--------获取未完成订单（即未确认收货）-------------------
  static Future<ProductOrder> productOrderGet(String id) async {
    var url = pre + "ProductOrderGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return ProductOrder.fromJson(m);
    }, enableJwt: true);
  }

  //--------获取未完成订单（即未确认收货）-------------------
  static Future<ProductOrder> productOrderHisGet(String id) async {
    var url = pre + "ProductOrderHisGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return ProductOrder.fromJson(m);
    }, enableJwt: true);
  }

//------------------------------------------------

}
