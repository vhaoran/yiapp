import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/master/master_order_detail.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/20 10:24
// usage ：通用的大师订单封面(订单包含六爻、四柱、合婚)
// ------------------------------------------------------

class MasterOrderCover extends StatefulWidget {
  // 是否展示用户资料，默认不展示(即默认显示大师资料)，在大师已完成历史订单中显示用户资料
  final bool showUser;
  final YiOrder yiOrder;

  MasterOrderCover({this.showUser: false, this.yiOrder, Key key})
      : super(key: key);

  @override
  _MasterOrderCoverState createState() => _MasterOrderCoverState();
}

class _MasterOrderCoverState extends State<MasterOrderCover> {
  YiOrder _order; // 单个订单详情

  @override
  void initState() {
    _order = widget.yiOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => CusRoute.push(
        context,
        MasterOrderDetail(
          id: _order.id,
          barName: _orderStr(),
          showUser: widget.showUser,
        ),
      ).then((val) {
        if (val != null) Navigator.pop(context);
      }),
      child: Card(
        color: fif_primary,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: _row(),
        ),
      ),
    );
  }

  Widget _row() {
    bool show = widget.showUser;
    return Row(
      children: <Widget>[
        // 大师或者用户头像
        CusAvatar(
          url: show ? _order.icon_ref : _order.master_icon_ref,
          rate: 20,
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 大师或者用户昵称
            CusText(
              show ? _order.nick_ref : _order.master_nick_ref,
              t_primary,
              28,
            ),
            SizedBox(height: 30),
            Row(
              children: <Widget>[
                CusText(_orderStr(), t_gray, 28), // 订单类型
                SizedBox(width: 40),
                // 下单时间 这里的 create_date 全数据为
                // 2020-10-20T01:42:17.682Z 非标准的时间格式，故只转换为年月日
                CusText("${CusTime.ymd(_order.create_date)}", t_gray, 28),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 订单类型
  String _orderStr() {
    var m = widget.yiOrder.content;
    if (m is LiuYaoContent) {
      return "六爻订单";
    } else if (m is SiZhuContent) {
      return "四柱订单";
    } else if (m is HeHunContent) {
      return "合婚订单";
    }
    return "未知类型订单";
  }
}
