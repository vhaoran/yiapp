import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/ui/mine/my_orders/post_his_main.dart';
import 'package:yiapp/ui/mine/my_orders/refund_main.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mine/my_orders/my_master_orders.dart';
import 'package:yiapp/ui/mine/my_orders/pay_await_main.dart';

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
            onTap: () => CusRoute.push(
              context,
              PostHisMain(post: Post(is_vie: false)),
            ),
          ),
          NormalBox(
            title: "闪断帖历史",
            onTap: () => CusRoute.push(
              context,
              PostHisMain(post: Post(is_vie: true)),
            ),
          ),
          NormalBox(
            title: "大师待处理订单",
            onTap: () => CusRoute.push(context, MyMasterOrders()),
          ),
          NormalBox(
            title: "投诉",
            onTap: () => CusRoute.push(context, RefundMainPage()),
          ),
        ],
      ),
    );
  }
}
