import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mine/my_orders/flash_post_his.dart';
import 'package:yiapp/ui/mine/my_orders/reward_post_his.dart';

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
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "悬赏帖历史",
          onTap: () => CusRoutes.push(context, RewardPostHis()),
        ),
        NormalBox(
          title: "闪断帖历史",
          onTap: () => CusRoutes.push(context, FlashPostHis()),
        ),
      ],
    );
  }
}
