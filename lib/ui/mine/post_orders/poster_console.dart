import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/ui/vip/user_post_unpaid_page.dart';
import 'package:yiapp/ui/vip/user_post_cancelled_page.dart';
import 'package:yiapp/ui/vip/user_post_his_page.dart';
import 'package:yiapp/ui/vip/user_post_doing_page.dart';
import 'package:yiapp/ui/mine/post_orders/poster_console_nav.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 下午5:07
// usage ：用户帖子控制台（处理中、待付款、已完成、已取消）
// ------------------------------------------------------

class PosterConsole extends StatefulWidget {
  PosterConsole({Key key}) : super(key: key);

  @override
  _PosterConsoleState createState() => _PosterConsoleState();
}

class _PosterConsoleState extends State<PosterConsole> {
  var _pc = PageController();
  int _curIndex = 0; // 当前导航栏索引

  // 大师控制台底部导航栏
  final Map<String, Widget> _mc = {
    "处理中": UserPostDoingPage(),
    "待付款": UserPostUnpaidPage(),
    "已完成": UserPostHisPage(),
    "已取消": UserPostCancelledPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _mc.length,
        itemBuilder: (context, index) => _mc.values.toList()[index],
      ),
      bottomNavigationBar: _cusNavigationBar(),
      backgroundColor: Colors.black26,
    );
  }

  /// 大师控制天底部导航栏
  Widget _cusNavigationBar() {
    return PosterConsoleNav(
      barNames: _mc.keys.toList(),
      onChanged: (int val) {
        if (val == null) return;
        if (_curIndex != val) {
          _curIndex = val;
          _pc.jumpToPage(_curIndex);
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }
}
