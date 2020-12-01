import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 11:22
// usage ：描述组件，如星座、生肖配对信息
// ------------------------------------------------------

class CusDescription extends StatelessWidget {
  final int iconValue; // 图标的值
  final String title;
  final String subtitle;

  const CusDescription({
    this.iconValue: 0,
    this.title: "",
    this.subtitle: "",
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          IconData(iconValue, fontFamily: ali_font),
          size: Adapt.px(100),
          color: t_yi,
        ),
        SizedBox(width: Adapt.px(20)),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: title,
                  style: TextStyle(color: t_yi, fontSize: Adapt.px(30)),
                ),
                TextSpan(
                  text: subtitle,
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
