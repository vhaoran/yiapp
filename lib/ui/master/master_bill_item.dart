import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/model/pays/master_business_res.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午11:44
// usage ：单个大师对账单对象
// ------------------------------------------------------

class MasterBillItem extends StatefulWidget {
  final MasterBusinessRes business;
  final bool isEarnings; // 是否为收益

  MasterBillItem({this.business, this.isEarnings: false, Key key})
      : super(key: key);

  @override
  _MasterBillItemState createState() => _MasterBillItemState();
}

class _MasterBillItemState extends State<MasterBillItem> {
  MasterBusinessRes _b; // 单个账单详情

  @override
  void initState() {
    _b = widget.business;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: fif_primary,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: _buildPayment(),
      ),
    );
  }

  /// 收益退款布局
  Widget _buildPayment() {
    Color color = widget.isEarnings ? btn_red : t_ji; // 收益为红，退款为绿
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CusText(_billType(_b.b_type), t_gray, 28),
            Spacer(), // 时间
            CusText("${CusTime.ymd(_b.created_at)}", Colors.grey, 30),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: <Widget>[
              CusText("${_b.amt}", color, 50), // 金额
              CusText(" 元", color, 30),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            CusText("交易对象:", Colors.grey, 30),
            SizedBox(width: Adapt.px(30)),
            CusText("${_b.summary}", t_gray, 30),
          ],
        ),
      ],
    );
  }

  /// 交易类型
  String _billType(String bType) {
    // 收益
    if (bType == b_yi_order) return "大师订单";
    if (bType == b_mall) return "商城订单";
    if (bType == b_bbs_prize) return "悬赏帖订单";
    if (bType == b_bbs_vie) return "闪断帖订单";
    // 支出
    if (bType == b_master_draw_money) return "提现";
    return "未知交易类型：$bType";
  }
}
