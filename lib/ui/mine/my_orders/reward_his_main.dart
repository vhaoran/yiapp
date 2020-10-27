import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/ui/mine/my_orders/reward_await_pay.dart';
import 'package:yiapp/ui/mine/my_orders/reward_cancel_pay.dart';
import 'package:yiapp/ui/mine/my_orders/reward_paid_pay.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 14:18
// usage ：悬赏帖历史
// ------------------------------------------------------

class RewardHisMain extends StatefulWidget {
  RewardHisMain({Key key}) : super(key: key);

  @override
  _RewardHisMainState createState() => _RewardHisMainState();
}

class _RewardHisMainState extends State<RewardHisMain> {
  final List<String> _tabs = ["待付款", "已付款", "已取消"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: '悬赏帖订单'),
        body: _bodyCtr(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _bodyCtr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(Adapt.px(8)),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => CusText(_tabs[i], t_gray, 28),
          ),
        ),
        SizedBox(height: Adapt.px(15)),
        Expanded(
          child: TabBarView(
            children: [
              RewardAwaitPay(), // 待付款
              RewardPaidPay(), // 已付款
              RewardCancelPay(), // 已取消
            ],
          ),
        ),
      ],
    );
  }
}
