import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/mine/post_orders/poster_await_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 下午5:21
// usage ：用户待付款的帖子订单主页
// ------------------------------------------------------

class PosterAwaitMain extends StatefulWidget {
  PosterAwaitMain({Key key}) : super(key: key);

  @override
  _PosterAwaitMainState createState() => _PosterAwaitMainState();
}

class _PosterAwaitMainState extends State<PosterAwaitMain> {
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
              PostAwaitPage(), // 用户待付款的悬赏帖
              PostAwaitPage(is_vie: true), // 用户待付款的闪断帖
            ],
          ),
        ),
      ],
    );
  }
}
