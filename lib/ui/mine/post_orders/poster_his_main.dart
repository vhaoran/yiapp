import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/ui/mine/post_orders/poster_cancel_page.dart';
import 'package:yiapp/ui/mine/post_orders/poster_his_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 下午5:28
// usage ：用户已完成的帖子订单主页
// ------------------------------------------------------

class PosterHisMain extends StatefulWidget {
  final bool is_vie;

  PosterHisMain({this.is_vie: false, Key key}) : super(key: key);

  @override
  _PosterHisMainState createState() => _PosterHisMainState();
}

class _PosterHisMainState extends State<PosterHisMain> {
  final List<String> _tabs = ["已付款", "已取消"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: '${widget.is_vie ? '闪断' : '悬赏'}帖订单'),
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
              PosterHisPage(
                post: Post(is_vie: widget.is_vie, is_his: true),
              ), // 已付款
              PosterCancelPage(
                post: Post(is_vie: widget.is_vie, is_his: true),
              ), // 已取消
            ],
          ),
        ),
      ],
    );
  }
}
