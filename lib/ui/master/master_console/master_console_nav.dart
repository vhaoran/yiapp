import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/badge/badge_data.dart';
import 'package:yiapp/widget/badge/su_badge.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/15 上午9:47
// usage ：大师工作台底部导航栏
// ------------------------------------------------------

class MasterConsoleNav extends StatefulWidget {
  final List<String> barNames;
  final FnInt onChanged;

  MasterConsoleNav({this.barNames, this.onChanged, Key key}) : super(key: key);

  @override
  _MasterConsoleNavState createState() => _MasterConsoleNavState();
}

class _MasterConsoleNavState extends State<MasterConsoleNav> {
  // 底部导航栏图标
  static const IconData _iconData0 = IconData(0xe676, fontFamily: ali_font);
  static const IconData _iconData1 = IconData(0xe675, fontFamily: ali_font);
  static const IconData _iconData2 = IconData(0xe609, fontFamily: ali_font);
  int _curIndex = 0; // 当前索引

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ter_primary,
      padding: EdgeInsets.symmetric(vertical: S.h(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ...List.generate(
            widget.barNames.length,
            (i) => _item(widget.barNames[i], i),
          ),
        ],
      ),
    );
  }

  Widget _item(String name, int i) {
    Color color = _curIndex == i ? t_primary : t_gray;
    return InkWell(
      onTap: () {
        if (_curIndex != i) {
          _curIndex = i;
          widget.onChanged(_curIndex);
          setState(() {});
        }
      },
      child: SizedBox(
        width: S.w(60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SuBadge(
              child: Icon(_iconData(i), size: S.w(24), color: color),
              hidden: true, // 是否隐藏未读消息个数组件
              shape: SuBadgeShape.spot,
              text: "99+", // 未读消息个数
            ),
            SizedBox(height: S.h(6)),
            Text(name, style: TextStyle(color: color, fontSize: S.sp(15))),
          ],
        ),
      ),
    );
  }

  /// 动态显示底部导航栏图标，因为Release下要求IconData必须为静态的
  IconData _iconData(int i) {
    switch (i) {
      case 0:
        return _iconData0;
        break;
      case 1:
        return _iconData1;
        break;
      case 2:
        return _iconData2;
        break;
      default:
        return _iconData0;
        break;
    }
  }
}
