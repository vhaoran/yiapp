import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
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
  final List<int> _codesInt = [0xe60c, 0xe624, 0xe6b2, 0xeba9];

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
          child: Icon(
            IconData(_codesInt[i], fontFamily: "AliIcon"),
            size: S.w(24),
          ),
          hidden: true, // 是否隐藏未读消息个数组件
          shape: SuBadgeShape.spot,
          text: "99+", // 未读消息个数
        ),
      ),
      title: Text(name),
    );
  }
}
