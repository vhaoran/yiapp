import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'base_week_bar.dart';

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  @override
  Widget getWeekBarItem(int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: S.h(3)),
      margin: EdgeInsets.symmetric(horizontal: S.w(5)),
      decoration: BoxDecoration(
        color: index > 4 ? t_red : t_primary,
        borderRadius: BorderRadius.circular(4), // 也可控件一边圆角大小
      ),
      child: Center(
        child: Text(
          weekList[index],
          style: TextStyle(color: sec_primary, fontSize: S.sp(15)),
        ),
      ),
    );
  }
}
