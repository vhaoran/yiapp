import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/vip/mall/user_mall_received_page.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/vip/mall/user_mall_shopcart_page.dart';
import 'package:yiapp/ui/vip/mall/user_mall_unreceived_page.dart';
import 'package:yiapp/ui/vip/mall/user_mall_paid_page.dart';
import 'package:yiapp/ui/vip/mall/user_mall_unpaid_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/2/1 上午9:32
// usage ：我的商品  含购物车、待付款、已付款、待收货、已收货
// ------------------------------------------------------

class UserMallOrderPage extends StatelessWidget {
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
            onTap: () => CusRoute.push(context, UserMallShopCartPage()),
          ),
          NormalBox(
            title: "待付款",
            onTap: () => CusRoute.push(context, UserMallUnpaidPage()),
          ),
          NormalBox(
            title: "已付款",
            onTap: () => CusRoute.push(context, UserMallPaidPage()),
          ),
          NormalBox(
            title: "待收货",
            onTap: () => CusRoute.push(context, UserMallUnreceivedPage()),
          ),
          NormalBox(
            title: "已收货",
            onTap: () => CusRoute.push(context, UserMallReceivedPage()),
          ),
        ],
      ),
    );
  }
}
