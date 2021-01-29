import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/ui/master/master_console/master_console_nav.dart';
import 'package:yiapp/ui/masters/master_prize_console_page.dart';
import 'package:yiapp/ui/masters/master_vie_console_page.dart';
import 'package:yiapp/ui/masters/yiorder/master_yiorder_doing_list_page.dart';

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
    "大师订单": MasterYiOrderDoingListPage(),
    "悬赏帖": MasterPrizeConsolePage(),
    "闪断帖": MasterVieConsolePage(),
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
