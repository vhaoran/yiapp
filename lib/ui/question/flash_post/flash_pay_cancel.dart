import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 10:53
// usage ：闪断帖，取消、支付、抢单功能
// ------------------------------------------------------

class FlashPayCancel extends StatefulWidget {
  final BBSVie data;
  final VoidCallback onChanged; // 取消和支付的回调

  FlashPayCancel({this.data, this.onChanged, Key key}) : super(key: key);

  @override
  _FlashPayCancelState createState() => _FlashPayCancelState();
}

class _FlashPayCancelState extends State<FlashPayCancel> {
  var _p = PayData();

  @override
  void initState() {
    _p = PayData(amt: widget.data.amt, b_type: b_bbs_prize, id: widget.data.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(5)),
      child: Row(
        children: <Widget>[
          Text(
            "${TimeUtil.parseYMD(widget.data.create_date)}", // 发帖时间
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          Spacer(),
          _cancelOrPay(),
        ],
      ),
    );
  }

  // 待付款状态，且本人帖子，显示取消和支付按钮
  Widget _cancelOrPay() {
    return Row(
      children: <Widget>[
        if (widget.data.stat == pay_await &&
            widget.data.uid == ApiBase.uid) ...[
          // 没有人回复时显示取消按钮(取消帖子功能)
          if (widget.data.reply.isEmpty)
            _comBtn(text: "取消", onPressed: _doCancel), // 取消订单
          SizedBox(width: S.w(5)),
          _comBtn(
            text: "支付", // 支付订单
            onPressed: () => BalancePay(context, data: _p),
          ),
          // 已付款状态，是大师，并且该单没有被抢，则显示抢单
          if (widget.data.stat == pay_paid &&
              (CusRole.is_master && widget.data.master_id == 0))
            _comBtn(text: "抢单", onPressed: _doGrab), // 大师抢单
        ],
      ],
    );
  }

  /// 取消订单
  void _doCancel() {
    CusDialog.err(context, title: "确定取消该订单吗?", onApproval: () async {
      try {
        bool ok = await ApiBBSVie.bbsVieCancel(widget.data.id);
        if (ok) {
          Log.info("取消订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          if (widget.onChanged != null) {
            widget.onChanged();
          }
        }
      } catch (e) {
        Log.error("取消订单出现异常：$e");
      }
    });
  }

  /// 大师抢单
  void _doGrab() async {
    try {
      BBSVie res = await ApiBBSVie.bbsVieAim(widget.data.id);
      if (res != null) {
        CusToast.toast(context, text: "抢单成功");
      }
    } catch (e) {
      Log.error("大师抢单出现异常：$e");
    }
  }

  Widget _comBtn({String text, VoidCallback onPressed}) {
    return Container(
      width: S.w(70),
      constraints: BoxConstraints(maxHeight: S.h(30)),
      child: CusRaisedButton(
        child: Text(text, style: TextStyle(fontSize: S.sp(14))),
        onPressed: onPressed,
        radius: 50,
        backgroundColor: primary,
      ),
    );
  }
}
