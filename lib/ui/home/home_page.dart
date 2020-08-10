import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
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
  final List<String> _barNames = ["大厅", "面对面", "命理圈", "我的"];
  List<Widget> _bars; // 底部导航栏
  int _curIndex = 0; // 底部导航栏索引

  @override
  void initState() {
    _bars = [
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
      body: _bars[_curIndex],
      bottomNavigationBar: _bottomAppBar(),
      backgroundColor: primary,
      floatingActionButton: GestureDetector(
        onTap: () => setState(() => _curIndex = 2),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 1)
            ],
          ),
          child:
              Image.asset('assets/images/tai_chi.png', width: 60, height: 60),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// 底部导航栏
  Widget _bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _barNames.map(
          (name) {
            int i = _barNames.indexWhere((e) => e == name);
            Color select = _curIndex == i ? t_primary : t_gray;
            return Row(
              children: <Widget>[
                CusSingleBar(
                  title: name,
                  titleColor: select,
                  iconColor: select,
                  length: _barNames.length,
                  icon: _icon(i),
                  onTap: () => setState(() => _curIndex = i),
                ),
                if (i == 1) SizedBox(width: 60),
              ],
            );
          },
        ).toList(),
      ),
      color: ter_primary,
      shape: CircularNotchedRectangle(),
    );
  }

  /// 动态获取底部导航栏图标
  IconData _icon(int i) {
    IconData icon;
    switch (i) {
      case 0:
        icon = IconData(0xe60e, fontFamily: 'AliIcon');
        break;
      case 1:
        icon = IconData(0xe616, fontFamily: 'AliIcon');
        break;
      case 2:
        icon = IconData(0xe71d, fontFamily: 'AliIcon');
        break;
      case 3:
        icon = IconData(0xe601, fontFamily: 'AliIcon');
        break;
      default:
        icon = FontAwesomeIcons.fastForward;
        break;
    }
    return icon;
  }
}
