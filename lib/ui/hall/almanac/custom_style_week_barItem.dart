import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';

import 'base_week_bar.dart';

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      decoration: new BoxDecoration(
        color: index > 4 ? t_red : t_primary,
        borderRadius: BorderRadius.circular(4), // 也可控件一边圆角大小
      ),
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: new Center(
        child: new Text(
          weekList[index],
          style: TextStyle(
            color: sec_primary,
          ),
        ),
      ),
    );
  }
}
