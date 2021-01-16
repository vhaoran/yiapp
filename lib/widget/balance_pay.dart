import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mine/fund_account/recharge_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'flutter/cus_toast.dart';
import 'small/cus_loading.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/23 下午5:06
// usage ：余额付款底部弹框
// ------------------------------------------------------

class BalancePay {
  final PayData data;
  final VoidCallback onCancel; // 取消支付后的回调
  final VoidCallback onSuccess; // 支付成功后的回调

  BalancePay(
    BuildContext context, {
    @required this.data,
    this.onCancel,
    this.onSuccess,
  }) {
    Log.info("BalancePay 订单详情：${data.toJson()}");
    _showBottomSheet(context);
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: tip_bg,
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
          height: S.screenH() / 1.5,
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
        SizedBox(height: S.h(5)),
        _closePay(context), // 关闭支付界面
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "￥",
              style: TextStyle(fontSize: S.sp(24), fontWeight: FontWeight.bold),
            ),
            Text(
              "${data.amt}.00",
              style: TextStyle(fontSize: S.sp(36), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: S.h(20)),
        _rowInfo("订单信息", _bType()),
        CusDivider(color: Colors.black54),
        _rowInfo("付款方式", "账户余额"),
        Spacer(),
        SizedBox(
          width: S.screenW(),
          child: CusRaisedButton(
            child: Text("立即付款"),
            backgroundColor: Color(0xFF3D77F1),
            onPressed: () => _doOrderPay(context, data),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "鸿运来支付",
            style: TextStyle(
              fontSize: S.sp(14),
              color: Colors.grey[500],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// 订单付款
  void _doOrderPay(BuildContext context, PayData payData) async {
    var m = {"amt": payData.amt, "b_type": payData.b_type, "id": payData.id};
    Log.info("订单详情：$m");
    try {
      SpinKit.ring(context, text: "正在支付...");
      var url = w_yi_trade + "OrderPay";
      bool ok = await ApiBase.postValue(url, m);
      if (ok != null) {
        await Future.delayed(Duration(milliseconds: 1500));
        Navigator.pop(context); // 关闭正在支付loading框
        CusToast.toast(context, text: "支付成功");
        Navigator.pop(context); // 关闭支付框
        if (onSuccess != null) onSuccess();
      }
    } catch (e) {
      if (e.toString().contains("余额不足")) {
        CusToast.toast(context, text: "余额不足，请充值", milliseconds: 1500);
        Navigator.pop(context);
        CusRoute.pushReplacement(
          context,
          RechargePage(amt: payData.amt, auto: true),
        );
      }
      Log.error("订单付款出现异常：$e");
    }
  }

  /// 关闭支付界面
  Widget _closePay(context) {
    return IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => CusDialog.normal(
        context,
        title: "是否放弃本次付款",
        textAgree: "继续付款",
        textCancel: "放弃",
        onCancel: () {
          Navigator.pop(context);
          if (onCancel != null) onCancel();
        },
      ),
    );
  }

  Widget _rowInfo(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          left,
          style: TextStyle(fontSize: S.sp(16), color: Colors.grey[700]),
        ),
        Text(right, style: TextStyle(fontSize: S.sp(16)))
      ],
    );
  }

  String _bType() {
    if (data.b_type == b_mall) return "商城订单付款";
    if (data.b_type == b_yi_order) return "大师订单付款";
    if (data.b_type == b_bbs_prize) return "悬赏帖付款";
    if (data.b_type == b_bbs_vie) return "闪断帖付款";
    if (data.b_type == b_recharge) return "充值";
    if (data.b_type == b_master_draw_money) return "大师提现";
    return "未知交易类型";
  }
}
