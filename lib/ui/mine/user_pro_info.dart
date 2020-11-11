import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mall/goods/shop_cart.dart';
import 'package:yiapp/ui/mall/goods/user_await_goods.dart';
import 'package:yiapp/ui/mall/goods/user_completed_goods.dart';
import 'package:yiapp/ui/mall/goods/user_wait_pay.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/11 15:56
// usage ：我的商品   含购物车、待付款、待收货、已完成订单
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
            onTap: () => CusRoutes.push(context, ShopCartPage()),
          ),
          NormalBox(
            title: "待付款",
            onTap: () => CusRoutes.push(context, AwaitPayment()),
          ),
          NormalBox(
            title: "待收货",
            onTap: () => CusRoutes.push(context, AwaitGetGoods()),
          ),
          NormalBox(
            title: "已完成订单",
            onTap: () => CusRoutes.push(context, CompletedGoods()),
          ),
        ],
      ),
    );
  }
}
