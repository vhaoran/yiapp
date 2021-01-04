import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/badge/badge_data.dart';
import 'package:yiapp/widget/badge/su_badge.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 下午5:00
// usage ：用户工作台底部导航栏
// ------------------------------------------------------

class PosterConsoleNav extends StatefulWidget {
  final int curIndex;
  final List<String> barNames;
  final FnInt onChanged;

  PosterConsoleNav({this.curIndex: 0, this.barNames, this.onChanged, Key key})
      : super(key: key);

  @override
  _PosterConsoleNavState createState() => _PosterConsoleNavState();
}

class _PosterConsoleNavState extends State<PosterConsoleNav> {
  // 底部导航栏图标
  static const IconData _iconData0 = IconData(0xe60c, fontFamily: ali_font);
  static const IconData _iconData1 = IconData(0xe624, fontFamily: ali_font);
  static const IconData _iconData2 = IconData(0xe6b2, fontFamily: ali_font);
  static const IconData _iconData3 = IconData(0xeba9, fontFamily: ali_font);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(
        widget.barNames.length,
        (i) => _barItem(widget.barNames[i], i),
      ),
      currentIndex: widget.curIndex,
      selectedFontSize: S.sp(14),
      unselectedFontSize: S.sp(14),
      selectedItemColor: t_primary,
      unselectedItemColor: t_gray,
      backgroundColor: ter_primary,
      type: BottomNavigationBarType.fixed,
    );
  }

  /// 底部导航栏名称
  BottomNavigationBarItem _barItem(String name, int i) {
    return BottomNavigationBarItem(
      icon: InkWell(
        onTap: () => widget.onChanged(i),
        child: SuBadge(
          child: Icon(_iconData(i), size: S.w(24)),
          hidden: true, // 是否隐藏未读消息个数组件
          shape: SuBadgeShape.spot,
          text: "99+", // 未读消息个数
        ),
      ),
      label: name,
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
      case 3:
        return _iconData3;
        break;
      default:
        return _iconData0;
        break;
    }
  }
}
