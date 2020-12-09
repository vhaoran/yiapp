import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/24 17:35
// usage ：悬赏帖、取消和支付按钮
// ------------------------------------------------------

class RewardPayCancel extends StatefulWidget {
  final BBSPrize data;
  final VoidCallback onChanged; // 取消和支付的回调

  RewardPayCancel({this.data, this.onChanged, Key key}) : super(key: key);

  @override
  _RewardPayCancelState createState() => _RewardPayCancelState();
}

class _RewardPayCancelState extends State<RewardPayCancel> {
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
        ],
      ],
    );
  }

  /// 取消订单
  void _doCancel() {
    CusDialog.normal(context, title: "确定取消该订单吗?", onApproval: () async {
      try {
        bool ok = await ApiBBSPrize.bbsPrizeCancel(_p.id);
        if (ok) {
          Log.info("取消订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          if (widget.onChanged != null) widget.onChanged();
        }
      } catch (e) {
        Log.error("取消订单出现异常：$e");
      }
    });
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
