import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/orders/refund_res.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午5:44
// usage ：通用的投诉订单封面
// ------------------------------------------------------

class RefundComCover extends StatelessWidget {
  final RefundRes refundRes;
  final String iconUrl;
  final String nick;

  RefundComCover({
    this.refundRes,
    this.iconUrl,
    this.nick,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fif_primary,
      margin: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
        child: _coverItem(refundRes, iconUrl, nick),
      ),
    );
  }

  Widget _coverItem(RefundRes res, String url, nick) {
    TextStyle tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        CusAvatar(url: url, rate: 20), // 大师或者用户的头像
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(nick, style: tPrimary), // 大师或者用户的昵称
                  Spacer(),
                  Text(
                    res.draw_back ? "退款 ${res.amt} 元宝" : "", // 退款金额
                    style: tGray,
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                constraints: BoxConstraints(minHeight: S.h(50)),
                child: Text(
                  res.brief, // 投诉大师的摘要
                  style: tGray,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _statView(res), // 投诉状态
                  Spacer(),
                  Text(res.create_date, style: tGray), // 投诉时间
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 显示投诉状态
  Widget _statView(RefundRes res) {
    if (res.stat == refund_await) {
      return Text("待审核",
          style: TextStyle(color: t_primary, fontSize: S.sp(15)));
    }
    if (res.stat == refund_b_pass) {
      return Text("待平台审核",
          style: TextStyle(color: t_primary, fontSize: S.sp(15)));
    }
    if (res.stat == refund_r) {
      return Text("已驳回", style: TextStyle(color: t_red, fontSize: S.sp(15)));
    }
    if (res.stat == refund_p_pass) {
      if (res.draw_back) {
        return Text("已退款",
            style: TextStyle(color: Colors.green, fontSize: S.sp(15)));
      }
      return Text("平台审核通过",
          style: TextStyle(color: t_primary, fontSize: S.sp(15)));
    }
    return SizedBox.shrink();
  }
}
