import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/badge/badge_data.dart';
import 'package:yiapp/widget/badge/su_badge.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/2 下午2:33
// usage ：自定义底部导航栏
// ------------------------------------------------------

class CusBottomNavigationBar extends StatefulWidget {
  final int curIndex;
  final List<String> barNames;
  final FnInt onChanged;

  CusBottomNavigationBar(
      {this.curIndex: 0, this.barNames, this.onChanged, Key key})
      : super(key: key);

  @override
  _CusBottomNavigationBarState createState() => _CusBottomNavigationBarState();
}

class _CusBottomNavigationBarState extends State<CusBottomNavigationBar> {
  // 底部导航栏图标
  static const IconData _luck = IconData(0xe618, fontFamily: ali_font);
  static const IconData _mall = IconData(0xe666, fontFamily: ali_font);
  static const IconData _que = IconData(0xe66b, fontFamily: ali_font);
  static const IconData _master = IconData(0xe605, fontFamily: ali_font);
  static const IconData _mine = IconData(0xe608, fontFamily: ali_font);

//  final List<int> _codesInt = [0xe618, 0xe666, 0xe66b, 0xe605, 0xe608];
  // 底部导航栏名称
  final List<String> _barNames = ["运势", "商城", "问命", "大师", "我的"];

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

  BottomNavigationBarItem _barItem(String name, int i) {
    int index = _barNames.indexOf(name);
    return BottomNavigationBarItem(
      icon: InkWell(
        onTap: () => widget.onChanged(i),
        child: SuBadge(
          child: Icon(_iconData(index), size: S.w(24)),
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
        return _luck;
        break;
      case 1:
        return _mall;
        break;
      case 2:
        return _que;
        break;
      case 3:
        return _master;
        break;
      case 4:
        return _mine;
        break;
      default:
        return _luck;
        break;
    }
  }
}
