import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午5:07
// usage ：如果是合婚，显示的内容（提交大师订单及查看订单可用）
// ------------------------------------------------------

class HeHunOrder extends StatelessWidget {
  final YiOrderHeHun heHun;

  HeHunOrder({this.heHun, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _comRow("男方姓名：", heHun.name_male),
        _comRow("出生日期：", _birthDate(true)),
        _comRow("女方姓名：", heHun.name_female),
        _comRow("出生日期：", _birthDate(false)),
      ],
    );
  }

  /// 出生日期
  String _birthDate(bool isMale) {
    DateTime time = heHun.dateTime(isMale); // 选择的年月日转换为DateTime
    bool solar = isMale ? heHun.is_solar_male : heHun.is_solar_female;
    DateTime date = solar ? time : TimeUtil.toSolar(time);
    return TimeUtil.YMDHM(date: date, isSolar: solar);
  }

  /// 通用的 Row
  Widget _comRow(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          Text(subtitle, style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        ],
      ),
    );
  }
}
