import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 20:02
// usage ：单个bottom_bar选项
// ------------------------------------------------------

class CusSingleBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final int length;
  final double iconSize;
  final double titleSize;
  final double width;
  final Color iconColor;
  final Color titleColor;
  final VoidCallback onTap;

  const CusSingleBar({
    this.icon,
    this.title: "暂无",
    this.iconSize: 50,
    this.titleSize: 26,
    this.length: 1,
    this.width,
    this.iconColor: t_primary,
    this.titleColor: t_primary,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? (Adapt.screenW() - Adapt.px(100)) / length,
        padding: EdgeInsets.only(top: Adapt.px(16), bottom: Adapt.px(2)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: Adapt.px(iconSize), color: iconColor),
            SizedBox(height: Adapt.px(20)),
            Text(
              title ?? "选项",
              style:
                  TextStyle(fontSize: Adapt.px(titleSize), color: titleColor),
            )
          ],
        ),
      ),
    );
  }
}
