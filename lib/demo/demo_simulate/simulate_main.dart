import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/const/const_string.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/pay/balance_pay.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/small/lack_balance.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午2:58
// usage ：关于虚拟场景的测试
// ------------------------------------------------------

class DemoSimulate extends StatelessWidget {
  DemoSimulate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "虚拟场景测试"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "01 模拟付款",
          onTap: () {
            BalancePay(
              context,
              data: PayData(amt: 12, b_type: b_p_order, id: "id"),
            );
          },
        ),
        NormalBox(
          title: "02 模拟充值",
          onTap: () {
            LackBalance(context, amt: 2);
          },
        ),
      ],
    );
  }
}
