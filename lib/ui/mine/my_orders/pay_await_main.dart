import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/ui/mine/my_orders/flash_await_pay.dart';
import 'package:yiapp/ui/mine/my_orders/reward_await_pay.dart';
import 'package:yiapp/ui/mine/my_orders/reward_cancel_pay.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/28 10:37
// usage ：待付款主页
// ------------------------------------------------------

class RewardAwaitMain extends StatefulWidget {
  RewardAwaitMain({Key key}) : super(key: key);

  @override
  _RewardAwaitMainState createState() => _RewardAwaitMainState();
}

class _RewardAwaitMainState extends State<RewardAwaitMain> {
  final List<String> _tabs = ["悬赏帖", "闪断帖"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: '待付款'),
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
              RewardAwaitPay(), // 悬赏帖待付款
              FlashAwaitPay(), // 闪断帖待付款
            ],
          ),
        ),
      ],
    );
  }
}
