import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/mine/my_orders/post_cancel_pay_his.dart';
import 'package:yiapp/ui/mine/my_orders/post_paid_pay.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/11 上午10:04
// usage ：帖子历史记录
// ------------------------------------------------------

class PostHisMain extends StatefulWidget {
  final bool isVie;

  PostHisMain({this.isVie: false, Key key}) : super(key: key);

  @override
  _PostHisMainState createState() => _PostHisMainState();
}

class _PostHisMainState extends State<PostHisMain> {
  final List<String> _tabs = ["已付款", "已取消"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: '${widget.isVie ? '闪断' : '悬赏'}帖订单'),
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
              PostPaidPay(isVie: widget.isVie, isHis: true), // 已付款
              PostCancelPayHis(isVie: widget.isVie, isHis: true), // 已取消
            ],
          ),
        ),
      ],
    );
  }
}
