import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 20:02
// usage ：单个bottom_bar选项
// ------------------------------------------------------

class CusSingleBar extends StatelessWidget {
  final int length;
  final String title;
  final Color iconColor;
  final Color titleColor;
  final IconData icon;
  final VoidCallback onTap;

  const CusSingleBar({
    this.length: 1,
    this.title: "标题",
    this.iconColor: t_gray,
    this.titleColor: t_gray,
    this.icon,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
}
