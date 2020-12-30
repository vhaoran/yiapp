import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/model/orders/yiOrder-liuyao.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/ui/mine/my_orders/hehun_order.dart';
import 'package:yiapp/ui/mine/my_orders/master_order.dart';
import 'package:yiapp/ui/mine/my_orders/sizhu_order.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/29 下午2:56
// usage ：查看约聊大师
// ------------------------------------------------------

class MeetMasterShow extends StatefulWidget {
  final YiOrder yiOrder;

  MeetMasterShow({this.yiOrder, Key key}) : super(key: key);

  @override
  _MeetMasterShowState createState() => _MeetMasterShowState();
}

class _MeetMasterShowState extends State<MeetMasterShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.all(S.w(15)),
        children: <Widget>[
          _masterInfo(), // 约聊大师的信息
          Divider(height: 15, thickness: 0.2, color: t_gray),
          Text("基本信息", style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          // 根据服务类型，动态显示结果
          _dynamicTypeView(),
          Divider(height: 15, thickness: 0.2, color: t_gray),
          Text("问题描述", style: TextStyle(color: t_primary, fontSize: S.sp(15))),
          SizedBox(height: S.h(5)),
          Text(
            widget.yiOrder.comment, // 问题描述
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          SizedBox(height: S.h(40)),
          _showBtn(stat: widget.yiOrder.stat),
        ],
      ),
    );
  }

  /// 根据订单状态显示
  Widget _showBtn({int stat}) {
    if (stat == bbs_init)
      return CusRaisedButton(
        child: Text("支付"),
        onPressed: () {
          PayData payData = PayData(
            amt: widget.yiOrder.amt,
            b_type: b_yi_order,
            id: widget.yiOrder.id,
          );
          BalancePay(context, data: payData);
        },
      );
    return SizedBox.shrink();
  }

  /// 约聊大师的信息
  Widget _masterInfo() {
    return Row(
      children: <Widget>[
        CusAvatar(url: widget.yiOrder.master_icon_ref), // 大师头像
        SizedBox(width: S.w(10)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _comRow("大师姓名：", widget.yiOrder.master_nick_ref),
              _comRow(
                "测算项目：",
                "${SwitchUtil.serviceType(widget.yiOrder.yi_cate_id)}",
              ),
              _comRow("服务价格：", "${widget.yiOrder.amt}"),
            ],
          ),
        ),
      ],
    );
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

  /// 根据服务类型，动态显示结果
  Widget _dynamicTypeView() {
    if (widget.yiOrder.content is YiOrderSiZhu) {
      return SiZhuOrder(siZhu: widget.yiOrder.content);
    } else if (widget.yiOrder.content is YiOrderHeHun) {
      return HeHunOrder(heHun: widget.yiOrder.content);
    } else if (widget.yiOrder.content is YiOrderLiuYao) {
      return MasterOrder(liuYao: widget.yiOrder.content);
      Log.info("这是测算六爻");
    }
  }
}
