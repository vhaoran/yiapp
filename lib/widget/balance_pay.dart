import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/23 下午5:06
// usage ：余额付款底部弹框
// ------------------------------------------------------

class BalancePay {
  final PayData data;
  final VoidCallback onCancel;

  BalancePay(
    BuildContext context, {
    @required this.data,
    this.onCancel,
  }) {
    _showBottomSheet(context);
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: tipBg,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: Adapt.screenH() / 1.5,
          child: _co(context),
        );
      },
    );
  }

  Widget _co(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            CusDialog.normal(context,
                title: "是否放弃本次付款",
                textAgree: "继续付款",
                textCancel: "放弃", onCancel: () {
              Navigator.pop(context);
              if (onCancel != null) {
                onCancel();
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("￥",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              "${data.amt}.00",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 20),
        _rowInfo("订单信息", _bType()),
        CusDivider(color: Colors.black54),
        _rowInfo("付款方式", "账户余额"),
        Spacer(),
        CusRaisedBtn(
          text: "立即付款",
          backgroundColor: Color(0xFF3D77F1),
          minWidth: double.infinity,
          onPressed: () {},
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Text(
            "鸿运来支付",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// 支付
  void _doPay() async {}

  Widget _rowInfo(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          left,
          style: TextStyle(fontSize: 15, color: Colors.grey[700]),
        ),
        Text(right, style: TextStyle(fontSize: 15))
      ],
    );
  }

  String _bType() {
    String str = "";
    switch (data.b_type) {
      case b_p_order:
        str = "商城订单付款";
        break;
      case b_yi_order:
        str = "大师订单付款";
        break;
      case b_bbs_prize:
        str = "悬赏帖付款";
        break;
      case b_bbs_vie:
        str = "闪断帖付款";
        break;
      case b_recharge:
        str = "充值";
        break;
      case b_master_draw_money:
        str = "大师提现";
        break;
      default:
        break;
    }
    return str;
  }
}
