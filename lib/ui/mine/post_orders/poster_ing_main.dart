import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/ui/mine/post_orders/poster_ing_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 上午9:19
// usage ：用户处理中的帖子订单主页
// ------------------------------------------------------

class PosterIngMain extends StatefulWidget {
  final Post post;

  PosterIngMain({this.post, Key key}) : super(key: key);

  @override
  _PosterIngMainState createState() => _PosterIngMainState();
}

class _PosterIngMainState extends State<PosterIngMain> {
  final List<String> _tabs = ["悬赏帖", "闪断帖"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "处理中"),
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
                style: TextStyle(color: t_gray, fontSize: S.sp(16))),
          ),
        ),
        SizedBox(height: S.h(5)),
        Expanded(
          child: TabBarView(
            children: [
              PosterIngPage(), // 用户处理中的悬赏帖
              PosterIngPage(is_vie: true), // 用户处理中的闪断帖
            ],
          ),
        ),
      ],
    );
  }
}
