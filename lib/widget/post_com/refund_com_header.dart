import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午6:22
// usage ：通用的投诉订单头部
// ------------------------------------------------------

class RefundComHeader extends StatelessWidget {
  final RefundRes refundRes;
  final String iconUrl;
  final String nick;

  RefundComHeader({this.refundRes, this.iconUrl, this.nick, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CusAvatar(url: iconUrl, rate: 20),
        SizedBox(width: S.w(10)),
        Expanded(child: _co()),
      ],
    );
  }

  Widget _co() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nick,
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ), // 昵称
        SizedBox(height: S.h(15)),
        Text(
          "投诉时间",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        Text(
          refundRes.create_date,
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      ],
    );
  }
}
