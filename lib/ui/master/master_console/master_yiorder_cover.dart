import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/ui/master/master_console/master_yiorder_page.dart';
import 'package:yiapp/ui/mine/exp_add_page.dart';
import 'package:yiapp/ui/mine/my_orders/meet_master_show.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 下午3:51
// usage ：大师订单封面
// ------------------------------------------------------

class MasterYiOrderCover extends StatefulWidget {
  final bool is_his; // 是否历史查询
  final YiOrder yiOrder;
  final VoidCallback onChanged;

  MasterYiOrderCover({
    this.is_his: false,
    this.yiOrder,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _MasterYiOrderCoverState createState() => _MasterYiOrderCoverState();
}

class _MasterYiOrderCoverState extends State<MasterYiOrderCover> {
  YiOrder _order; // 单个订单详情

  @override
  void initState() {
    _order = widget.yiOrder;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pushPage,
      child: Card(
        color: fif_primary,
        child: Padding(padding: EdgeInsets.all(S.w(5)), child: _row()),
      ),
    );
  }

  Widget _row() {
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle tPrimary = TextStyle(color: t_primary, fontSize: S.sp(15));
    // 动态显示大师、用户头像
    bool isMaster = CusRole.is_master;
    String url = isMaster ? _order.icon_ref : _order.master_icon_ref;
    String nick = isMaster ? _order.nick_ref : _order.master_nick_ref;
    return Row(
      children: <Widget>[
        // 头像
        CusAvatar(url: url, rate: 20),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(nick, style: tPrimary), // 昵称
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
                  _showBtn(_order.stat),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 显示按钮
  Widget _showBtn(int stat) {
    Log.info("订单状态：$stat");
    if (stat == bbs_init) {
      return Container(
        width: S.w(70),
        constraints: BoxConstraints(maxHeight: S.h(30)),
        child: CusRaisedButton(
          child: Text("支付", style: TextStyle(fontSize: S.sp(14))),
          onPressed: () {
            PayData payData = PayData(
              amt: _order.amt,
              b_type: b_yi_order,
              id: _order.id,
            );
            BalancePay(context, data: payData);
          },
          borderRadius: 50,
          backgroundColor: Colors.black54,
        ),
      );
    } else if (stat == bbs_paid) {
      return Container(
        width: S.w(70),
        constraints: BoxConstraints(maxHeight: S.h(30)),
        child: CusRaisedButton(
          child: Text("回复", style: TextStyle(fontSize: S.sp(14))),
          onPressed: _pushPage,
          borderRadius: 50,
          backgroundColor: Colors.lightBlue,
        ),
      );
    } else if (stat == bbs_ok) {
      return Container(
        width: S.w(70),
        constraints: BoxConstraints(maxHeight: S.h(30)),
        child: CusRaisedButton(
          child: Text("评价", style: TextStyle(fontSize: S.sp(14))),
          onPressed: () => CusRoute.push(
            context,
            ExpAddPage(yiOrder: widget.yiOrder),
          ).then((value) {
            if (value != null && widget.onChanged != null) widget.onChanged();
          }),
          borderRadius: 50,
          backgroundColor: Colors.lightBlue,
        ),
      );
    }
    return SizedBox.shrink();
  }

  /// 根据情况跳转页面
  void _pushPage() {
    if (_order.stat == bbs_init || _order.stat == bbs_ok) {
      CusRoute.push(context, MeetMasterShow(yiOrder: widget.yiOrder));
    }
    if (_order.stat == bbs_paid) {
      CusRoute.push(
        context,
        MasterYiOrderPage(id: widget.yiOrder.id, is_his: widget.is_his),
      );
    }
  }
}
