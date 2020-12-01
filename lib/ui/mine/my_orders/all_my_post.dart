import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mine/my_orders/flash_his_main.dart';
import 'package:yiapp/ui/mine/my_orders/my_master_orders.dart';
import 'package:yiapp/ui/mine/my_orders/pay_await_main.dart';
import 'package:yiapp/ui/mine/my_orders/reward_his_main.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 14:20
// usage ：订单详情
// ------------------------------------------------------

class AllMyPostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "订单详情"),
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
            title: "待付款",
            onTap: () => CusRoute.push(context, RewardAwaitMain()),
          ),
          NormalBox(
            title: "悬赏帖历史",
            onTap: () => CusRoute.push(context, RewardHisMain()),
          ),
          NormalBox(
            title: "闪断帖历史",
            onTap: () => CusRoute.push(context, FlashHisMain()),
          ),
          NormalBox(
            title: "大师待处理订单",
            onTap: () => CusRoute.push(context, MyMasterOrders()),
          ),
        ],
      ),
    );
  }
}
