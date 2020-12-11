import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/mine/my_orders/post_cancelled_his.dart';
import 'package:yiapp/ui/mine/my_orders/post_paid_his.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

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
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.only(bottom: 3),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => Text(_tabs[i],
                style: TextStyle(color: t_gray, fontSize: S.sp(15))),
          ),
        ),
        SizedBox(height: S.h(5)),
        Expanded(
          child: TabBarView(
            children: [
              PostPaidHis(isVie: widget.isVie, isHis: true), // 已付款
              PostCancelledHis(isVie: widget.isVie, isHis: true), // 已取消
            ],
          ),
        ),
      ],
    );
  }
}
