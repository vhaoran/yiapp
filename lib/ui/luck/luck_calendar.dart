import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/fortune/almanac/almanac_page.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/flutter/button_plugins.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/su_button.dart';

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
            _yiOrJiCts(Lunar(DateTime.now()).dayYi), // 宜
            _yiOrJiCts(Lunar(DateTime.now()).dayJi,
                color: t_ji, isYi: false), // 忌
          ],
        ),
      ],
    );
  }

  Widget _dateTimeShow(context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "${TimeUtil.dateYMD()}  ${TimeUtil.ganZhi()}年${TimeUtil.lunarMD()}",
        style: TextStyle(
          color: t_primary,
          fontSize: 24,
        ),
      ),
    );
  }

  /// 封装的宜忌组件
  Widget _yiOrJiCts(List<String> l, {Color color = t_yi, bool isYi = true}) {
    l.insert(0, isYi ? "宜" : "忌");
    final int max = 8;
    return Row(
      children: List.generate(
        l.length >= max ? max : l.length,
        (index) {
          return Container(
            padding: EdgeInsets.all(Adapt.px(6)),
            width: Adapt.screenW() / max,
            child: Text(
              l[index],
              style: TextStyle(color: color, fontSize: Adapt.px(28)),
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
