import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/ui/mine/post_orders/poster_await_main.dart';
import 'package:yiapp/ui/mine/post_orders/poster_his_main.dart';
import 'package:yiapp/ui/mine/post_orders/poster_ing_main.dart';
import 'package:yiapp/ui/mine/post_orders/poster_console_nav.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 下午5:07
// usage ：用户控制台
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
    "处理中": PosterIngMain(),
    "待付款": PosterAwaitMain(),
    "已完成": PosterHisMain(),
    "已取消": PosterIngMain(),
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
      curIndex: _curIndex,
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
