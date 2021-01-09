import 'package:flutter/cupertino.dart';
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
  final List<String> barNames;
  final FnInt onChanged;

  CusBottomNavigationBar({this.barNames, this.onChanged, Key key})
      : super(key: key);

  @override
  _CusBottomNavigationBarState createState() => _CusBottomNavigationBarState();
}

class _CusBottomNavigationBarState extends State<CusBottomNavigationBar> {
  final List<String> _barNames = ["运势", "商城", "问命", "大师", "我的"];
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
    int index = _barNames.indexOf(name); // 动态获取底部导航图标
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
        width: S.w(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SuBadge(
              child: Icon(_iconData(index), size: S.w(24), color: color),
              hidden: true, // 是否隐藏未读消息个数组件
              shape: SuBadgeShape.spot,
              text: "99+", // 未读消息个数
            ),
            SizedBox(height: S.h(3)),
            Text(name, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  /// 动态显示底部导航栏图标，因为Release下要求IconData必须为静态的
  IconData _iconData(int i) {
    if (i == 0) return _luck;
    if (i == 1) return _mall;
    if (i == 2) return _que;
    if (i == 3) return _master;
    if (i == 4) return _mine;
    return _luck;
  }

  // 底部导航栏图标
  static const IconData _luck = IconData(0xe618, fontFamily: ali_font);
  static const IconData _mall = IconData(0xe666, fontFamily: ali_font);
  static const IconData _que = IconData(0xe66b, fontFamily: ali_font);
  static const IconData _master = IconData(0xe605, fontFamily: ali_font);
  static const IconData _mine = IconData(0xe608, fontFamily: ali_font);
}
