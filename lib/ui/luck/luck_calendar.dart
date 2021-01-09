import 'package:flutter/material.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/fortune/almanac/almanac_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/2 下午3:51
// usage ：【每日运势】- 日历，宜忌注意事项
// ------------------------------------------------------

class LuckCalendar extends StatelessWidget {
  LuckCalendar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _timeView(context),
        Column(
          children: <Widget>[
            _yiOrJiData(isYi: true), // 宜
            _yiOrJiData(isYi: false), // 忌
          ],
        ),
      ],
    );
  }

  Widget _timeView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: S.h(8)),
          child: Text(
            "${TimeUtil.YMD()}  ${TimeUtil.ganZhi()}年${TimeUtil.lunarMD()}",
            style: TextStyle(color: t_primary, fontSize: S.sp(18)),
          ),
        ),
        SizedBox(width: S.w(12)),
        InkWell(
          onTap: () => CusRoute.push(context, AlmanacPage()),
          child: Text(
            "详情",
            style: TextStyle(color: Colors.lightBlue, fontSize: S.sp(15)),
          ),
        ),
        SizedBox(width: S.w(8)),
      ],
    );
  }

  /// 宜忌数据
  Widget _yiOrJiData({bool isYi}) {
    Lunar lunar = Lunar(DateTime.now());
    List<String> l = isYi ? lunar.dayYi : lunar.dayJi;
    l.insert(0, isYi ? "宜" : "忌"); // 第一个显示类型
    Color color = isYi ? t_yi : t_ji;
    final int max = 8; // 最大可显示数据个数
    return Row(
      children: List.generate(
        l.length >= max ? max : l.length,
        (i) {
          // 只获取前两个字
          String str = l[i].length >= 2 ? l[i].substring(0, 2) : l[i];
          return Container(
            padding: EdgeInsets.all(S.w(5)),
            constraints: BoxConstraints(maxHeight: S.h(30)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700], width: 0),
            ),
            width: S.screenW() / max,
            child: Text(
              str, // 显示的宜忌内容
              style: TextStyle(color: color, fontSize: S.sp(15)),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}
