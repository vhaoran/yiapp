import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
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
  final List<int> _codesInt = [0xe618, 0xe666, 0xe66b, 0xe605, 0xe608];
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
      selectedFontSize: S.sp(15),
      unselectedFontSize: S.sp(15),
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
        child: Padding(
          padding: EdgeInsets.only(bottom: S.h(5)),
          child: SuBadge(
            child: Icon(
              IconData(_codesInt[index], fontFamily: "AliIcon"),
              size: S.w(26),
            ),
            hidden: true, // 是否隐藏未读消息个数组件
            shape: SuBadgeShape.spot,
            text: "99+", // 未读消息个数
          ),
        ),
      ),
      title: Text(name),
    );
  }
}
