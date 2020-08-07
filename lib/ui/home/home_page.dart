import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_option.dart';
import 'package:yiapp/complex/widgets/cus_singlebar.dart';
import 'package:yiapp/ui/ask_fate/ask_fate.dart';
import 'package:yiapp/ui/face_to_face/face_to_face_page.dart';
import 'package:yiapp/ui/fate_circle/fate_circle_page.dart';
import 'package:yiapp/ui/hall/hall_page.dart';
import 'package:yiapp/ui/mine/mine_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:15
// usage ：首页
// ------------------------------------------------------

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _curIndex = 0; // 底部导航栏索引
  // 底部导航栏
  List _bottomBar;

  @override
  void initState() {
    _bottomBar = [
      HallPage(),
      FaceToFacePage(),
      AskFatePage(),
      FateCirclePage(),
      MinePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomBar[_curIndex],
      backgroundColor: primary,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CusSingleBar(),
            CusSingleBar(),
            CusSingleBar(),
            CusSingleBar(),
          ],
        ),
        color: ter_primary,
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: null),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
