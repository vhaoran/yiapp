import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/mine/my_orders/post_await_pay.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

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
          indicatorWeight: S.w(3),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(S.w(4)),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => Text(_tabs[i],
                style: TextStyle(color: t_gray, fontSize: S.sp(15))),
          ),
        ),
        SizedBox(height: S.h(10)),
        Expanded(
          child: TabBarView(
            children: [
              PostAwaitPay(isVie: false), // 悬赏帖待付款
              PostAwaitPay(isVie: true), // 闪断帖待付款
            ],
          ),
        ),
      ],
    );
  }
}
