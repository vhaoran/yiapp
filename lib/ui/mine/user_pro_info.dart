import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/mall/goods/had_get_goods_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mall/goods/shop_cart.dart';
import 'package:yiapp/ui/mall/goods/await_get_goods_page.dart';
import 'package:yiapp/ui/mall/goods/paid_goods_page.dart';
import 'package:yiapp/ui/mall/goods/await_pay_goods_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/11 15:56
// usage ：我的商品  含购物车、待付款、已付款、待收货、已收货
// ------------------------------------------------------

class UserProductInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "我的商品"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          NormalBox(
            title: "购物车",
            onTap: () => CusRoute.push(context, ShopCartPage()),
          ),
          NormalBox(
            title: "待付款",
            onTap: () => CusRoute.push(context, AwaitPayGoodsPage()),
          ),
          NormalBox(
            title: "已付款",
            onTap: () => CusRoute.push(context, PaidGoodsPage()),
          ),
          NormalBox(
            title: "待收货",
            onTap: () => CusRoute.push(context, AwaitGetGoodsPage()),
          ),
          NormalBox(
            title: "已收货",
            onTap: () => CusRoute.push(context, HadGetGoodsPage()),
          ),
        ],
      ),
    );
  }
}
