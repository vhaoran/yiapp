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
        InkWell(
          onTap: () => CusRoute.push(context, AlmanacPage()),
          child: _dateTimeShow(context),
        ),
        Column(
          children: <Widget>[
            _yiOrJiData(isYi: true), // 宜
            _yiOrJiData(isYi: false), // 忌
          ],
        ),
      ],
    );
  }

  Widget _dateTimeShow(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: S.h(8)),
      child: Text(
        "${TimeUtil.dateYMD()}  ${TimeUtil.ganZhi()}年${TimeUtil.lunarMD()}",
        style: TextStyle(color: t_primary, fontSize: S.sp(18)),
      ),
    );
  }

  /// 宜忌数据
  Widget _yiOrJiData({bool isYi}) {
    List<String> l =
        isYi ? Lunar(DateTime.now()).dayYi : Lunar(DateTime.now()).dayJi;
    l.insert(0, isYi ? "宜" : "忌");
    Color color = isYi ? t_yi : t_ji;
    final int max = 8;
    return Row(
      children: List.generate(
        l.length >= max ? max : l.length,
        (i) {
          return Container(
            padding: EdgeInsets.all(S.w(5)),
            width: S.screenW() / max,
            child: Text(
              l[i],
              style: TextStyle(color: color, fontSize: S.sp(15)),
              overflow: TextOverflow.ellipsis,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700], width: 0),
            ),
          );
        },
      ),
    );
  }
}
