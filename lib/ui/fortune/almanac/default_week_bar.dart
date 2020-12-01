import 'package:flutter/material.dart';

import 'base_week_bar.dart';
import '../../../const/cus_calendar.dart';
import 'style.dart';

///**
// * 顶部的固定的周显示
// */
//class DefaultWeekBar extends StatelessWidget {
//  const DefaultWeekBar({Key key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: new Row(
//        children: getWeekDayWidget(),
//      ),
//    );
//  }
//}
//
//List<Widget> getWeekDayWidget() {
//  return List.generate(7, (index) {
//    return getChild(Constants.WEEK_LIST[index]);
//  });
//}
//
//Widget getChild(String title) {
//  return new Expanded(
//      child: new Container(
//    color: RandomColor.next(),
//    height: 40,
//    alignment: Alignment.center,
//    child: new Text(
//      title,
//      style: topWeekTextStyle,
//    ),
//  ));
//}

class DefaultWeekBar extends BaseWeekBar {
  const DefaultWeekBar({Key key}) : super(key: key);

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      height: 40,
      alignment: Alignment.center,
      child: new Text(
        CusYiData.weeks[index],
        style: topWeekTextStyle,
      ),
    );
  }
}
