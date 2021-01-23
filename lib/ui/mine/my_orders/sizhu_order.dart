import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/sizhu_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 上午11:34
// usage ：如果是四柱，显示的内容（提交大师订单及查看订单可用）
// ------------------------------------------------------

class SiZhuOrder extends StatelessWidget {
  final SiZhuRes siZhu;

  SiZhuOrder({this.siZhu, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _comRow("姓名：", siZhu.name),
        _comRow("性别：", siZhu.is_male ? "男" : "女"),
        _comRow("出生日期：", _birthDate()),
      ],
    );
  }

  /// 出生日期
  String _birthDate() {
    DateTime time = siZhu.dateTime(); // 选择的年月日转换为DateTime
    DateTime date = siZhu.is_solar ? time : TimeUtil.toSolar(time);
    return TimeUtil.YMDHM(date: date, isSolar: siZhu.is_solar);
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
