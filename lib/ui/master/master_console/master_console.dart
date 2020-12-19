import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'master_await_main.dart';
import 'master_prize_main.dart';
import 'master_vie_main.dart';
import 'master_console_nav.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/14 下午5:23
// usage ：大师控制台
// ------------------------------------------------------

class MasterConsole extends StatefulWidget {
  MasterConsole({Key key}) : super(key: key);

  @override
  _MasterConsoleState createState() => _MasterConsoleState();
}

class _MasterConsoleState extends State<MasterConsole> {
  var _pc = PageController();
  int _curIndex = 0; // 当前导航栏索引
  // 大师控制台底部导航栏
  final Map<String, Widget> _mc = {
    "悬赏帖": MasterPrizeMain(),
    "闪断帖": MasterVieMain(),
    "大师订单": MasterAwaitMain(),
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
    return MasterConsoleNav(
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
