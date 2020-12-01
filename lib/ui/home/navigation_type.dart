import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/small/cus_singlebar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/22 17:03
// usage ：底部导航栏
// ------------------------------------------------------

class NavigationType extends StatefulWidget {
  int curIndex;
  List<String> barNames;
  FnInt onChanged;

  NavigationType({
    this.curIndex: 0,
    this.barNames,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _NavigationTypeState createState() => _NavigationTypeState();
}

class _NavigationTypeState extends State<NavigationType> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ...widget.barNames.map((name) {
            int i = widget.barNames.indexOf(name);
            Color select = widget.curIndex == i ? t_primary : t_gray;
            return _barItem(
              length: widget.barNames.length,
              title: name,
              titleColor: select,
              iconColor: select,
              icon: _icon(i),
              onTap: () {
                if (widget.onChanged != null) {
                  widget.onChanged(i);
                }
              },
            );
          }),
        ],
      ),
      color: ter_primary,
      shape: CircularNotchedRectangle(),
    );
  }

  /// 底部导航栏
  Widget _barItem({
    int length,
    String title,
    Color iconColor,
    Color titleColor,
    IconData icon,
    VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: Adapt.screenW() / length,
        padding: EdgeInsets.only(top: 5, bottom: Adapt.px(2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 28, color: iconColor),
            SizedBox(height: 5),
            Text(
              title ?? "选项",
              style: TextStyle(fontSize: Adapt.px(26), color: titleColor),
            )
          ],
        ),
      ),
    );
  }

  /// 动态获取底部导航栏图标
  IconData _icon(int i) {
    IconData icon;
    switch (i) {
      case 0:
        icon = IconData(0xe618, fontFamily: 'AliIcon');
        break;
      case 1:
        icon = IconData(0xe66b, fontFamily: 'AliIcon');
        break;
      case 2:
        icon = IconData(0xe666, fontFamily: 'AliIcon');
        break;
      case 3:
        icon = IconData(0xe605, fontFamily: 'AliIcon');
        break;
      case 4:
        icon = IconData(0xe608, fontFamily: 'AliIcon');
        break;
      default:
        icon = FontAwesomeIcons.fastForward;
        break;
    }
    return icon;
  }
}
