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
    this.icon: Icons.broken_image,
    this.title: "暂无",
    this.iconSize: 22,
    this.titleSize: 12,
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
        width: width ?? (Adapt.screenW() - 150) / length,
        padding: EdgeInsets.only(top: 8, bottom: 1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon ?? Icons.broken_image, size: iconSize, color: iconColor),
            SizedBox(height: 3),
            Text(
              title ?? "选项",
              style: TextStyle(fontSize: titleSize, color: titleColor),
            )
          ],
        ),
      ),
    );
  }
}
