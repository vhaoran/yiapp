import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mine/my_post/reward_his_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 11:55
// usage ：我的帖子
// ------------------------------------------------------

class AllMyPostPage extends StatefulWidget {
  AllMyPostPage({Key key}) : super(key: key);

  @override
  _AllMyPostPageState createState() => _AllMyPostPageState();
}

class _AllMyPostPageState extends State<AllMyPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: '我的帖子'),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "悬赏帖历史",
          onTap: () => CusRoutes.push(context, RewardPostHisPage()),
        ),
        NormalBox(title: "闪断帖历史", onTap: () {}),
      ],
    );
  }
}
