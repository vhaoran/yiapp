import 'dart:convert';
import 'package:yiapp/model/orders/cus_order_data.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/16 10:03
// usage ：购物车本地数据
// ------------------------------------------------------

class ShopKV {
  static String key = ""; // 登录时不同用户切换购物车存储的key

  /// 获取本地购物车数据
  static Future<String> load() async {
    if ("${ApiBase.uid}" == key.substring(4)) {
      return await KV.getStr(key);
    }
    return null;
  }

  /// 更新本地购物车数据
  static Future<bool> refresh(AllShopData data) async {
    return await KV.setStr(key, json.encode(data.toJson()));
  }

  /// 清空本地购物车数据
  static Future<bool> clear() async {
    return await KV.remove(key);
  }

  /// 本地数据转换为实体类
  static Future<AllShopData> from(String res) async {
    return AllShopData.fromJson(json.decode(res));
  }

  /// 向购物车中添加数据
  static Future<AllShopData> add(String res, SingleShopData order) async {
    AllShopData allShop = await ShopKV.from(res);
    SingleShopData shop = allShop.shops.singleWhere(
        (e) =>
            e.product.id_of_es == order.product.id_of_es &&
            e.color.code == order.color.code,
        orElse: () => null);
    if (shop == null) {
      // 1、添加新商品。
      allShop.shops.add(order);
    } else {
      // 2、添加同一商品的同一颜色时，只需要增加对应数量即可
      shop.count += order.count;
    }
    return allShop;
  }

  /// 从本地数据中删除购物车商品
  static Future<AllShopData> remove(AllShopData e) async {
    AllShopData allShops;
    String res = await load();
    if (res != null) {
      allShops = await ShopKV.from(res);
      for (var i = 0; i < e.shops.length; i++) {
        var now = e.shops[i];
        SingleShopData shop = allShops.shops.singleWhere(
            (all) =>
                all.product.id_of_es == now.product.id_of_es &&
                all.color.code == now.color.code,
            orElse: () => null);
        if (shop != null) allShops.shops.remove(shop);
      }
    }
    return allShops;
  }
}
