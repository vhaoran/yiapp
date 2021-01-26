import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 上午9:17
// usage ：通用的大师订单封面
// ------------------------------------------------------

class YiOrderComCover extends StatefulWidget {
  final YiOrder yiOrder;
  final String iconUrl;
  final String nick;
  final Widget child;

  YiOrderComCover({
    this.yiOrder,
    this.iconUrl,
    this.nick,
    this.child,
    Key key,
  }) : super(key: key);

  @override
  _YiOrderComCoverState createState() => _YiOrderComCoverState();
}

class _YiOrderComCoverState extends State<YiOrderComCover> {
  YiOrder _order; // 单个订单详情

  @override
  void initState() {
    _order = widget.yiOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fif_primary,
      child: Padding(padding: EdgeInsets.all(S.w(5)), child: _row()),
    );
  }

  Widget _row() {
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        // 头像
        CusAvatar(url: widget.iconUrl, rate: 20),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(widget.nick, style: tPrimary), // 昵称
                  Spacer(),
                  Text("${_order.amt} 元宝", style: tPrimary), // 用户付款金额
                ],
              ),
              // 大师服务项目类型
              SizedBox(height: S.h(10)),
              Text(SwitchUtil.serviceType(_order.yi_cate_id), style: gray),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // 下单时间 这里的 create_date 全数据为
                  // 2020-10-20T01:42:17.682Z 非标准的时间格式，故只转换为年月日
                  Text("${CusTime.ymd(_order.create_date)}", style: gray),
                  Spacer(),
                  widget.child, // 动态显示支付、评价、回复按钮
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
