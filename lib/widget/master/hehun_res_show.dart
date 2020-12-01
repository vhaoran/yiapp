import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/23 17:23
// usage ：显示合婚结果
// ------------------------------------------------------

class HeHunResShow extends StatelessWidget {
  final String sex; // 男 女
  final String name;
  final String time;

  HeHunResShow({this.sex, this.name, this.time, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CusDivider(),
        CusText("$sex方信息", t_primary, 30),
        SizedBox(height: Adapt.px(20)),
        Row(
          children: <Widget>[
            CusText("姓名：", t_primary, 30),
            CusText(name, t_gray, 30),
          ],
        ),
        SizedBox(height: Adapt.px(10)),
        Row(
          children: <Widget>[
            CusText("出生日期：", t_primary, 30),
            CusText(time, t_gray, 30),
          ],
        ),
      ],
    );
  }
}
