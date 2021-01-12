import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/model/pays/business.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/24 15:32
// usage ：单个对账单对象
// ------------------------------------------------------

// Business 类参数解释

// [action]:业务类型 大于0为收入，小于0为支出，具体如
// 1 充值、2 分润、3 退款、-1 测算消费、-2 商城消费 更多扩充待定

// [amt] 具体金额、

// [amtStart] 这笔账单结束后的余额、[summary] 账单类型概要

// [tradeNo] 账单id、[id] 当前账单位于总订单历史记录的哪一位置

class BillItem extends StatefulWidget {
  final Business business;

  BillItem({this.business, Key key}) : super(key: key);

  @override
  _BillItemState createState() => _BillItemState();
}

class _BillItemState extends State<BillItem> {
  Business _b; // 单个账单详情

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

  /// 收付款布局
  Widget _buildPayment() {
    Color color = _b.amt > 0 ? btn_red : t_ji; // 余额中支付为红，收款为绿
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CusText("交易对象:", Colors.grey, 30),
            SizedBox(width: Adapt.px(30)),
            CusText("${_b.summary}", t_gray, 30),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: <Widget>[
              CusText("${_b.amt}", color, 50), // 金额
              CusText(" 元", color, 30),
              Spacer(),
              CusText("期初: ${_b.amtStart} 元", t_gray, 30),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: CusText("${CusTime.ymd(_b.created_at)}", Colors.grey, 30),
        ),
      ],
    );
  }
}
