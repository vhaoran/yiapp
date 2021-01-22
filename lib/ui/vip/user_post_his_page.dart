import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/mine/post_orders/poster_his_page.dart';
import 'package:yiapp/ui/vip/prize/user_prize_his_main.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 上午11:52
// usage ：会员已完成帖子页面
// ------------------------------------------------------

class UserPostHisPage extends StatefulWidget {
  final bool is_vie;

  UserPostHisPage({this.is_vie: false, Key key}) : super(key: key);

  @override
  _UserPostHisPageState createState() => _UserPostHisPageState();
}

class _UserPostHisPageState extends State<UserPostHisPage> {
  final List<String> _tabs = ["悬赏帖", "闪断帖"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "已完成"),
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
              UserPrizeHisMain(), // 用户已打赏悬赏帖订单
//              PosterHisPage(),
              PosterHisPage(is_vie: true), // 用户已打赏闪断帖订单
            ],
          ),
        ),
      ],
    );
  }
}
