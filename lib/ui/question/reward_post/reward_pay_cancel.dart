import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/tools/date_util.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/pay/balance_pay.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mine/com_pay_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/24 17:35
// usage ：悬赏帖、取消和支付按钮
// ------------------------------------------------------

class RewardPayCancel extends StatefulWidget {
  final BBSPrize data;
  VoidCallback onChanged; // 取消和支付的回调

  RewardPayCancel({this.data, this.onChanged, Key key}) : super(key: key);

  @override
  _RewardPayCancelState createState() => _RewardPayCancelState();
}

class _RewardPayCancelState extends State<RewardPayCancel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              bottom: Adapt.px(widget.data.stat != pay_await ? 20 : 0)),
          child: CusText(
            "${CusTime.ymd(widget.data.create_date)}", // 发帖时间
            t_gray,
            28,
          ),
        ),
        Spacer(),
        // 待付款状态，且本人帖子
        if (widget.data.stat == pay_await &&
            widget.data.uid == ApiBase.uid) ...[
          // 没有人回复时显示取消按钮(取消帖子功能)
          if (widget.data.reply.isEmpty)
            _comBtnCtr("取消", onPressed: _doCancel), // 取消订单
          SizedBox(width: Adapt.px(20)),
          _comBtnCtr("支付", onPressed: _doPay), // 支付订单
        ],
      ],
    );
  }

  /// 取消订单
  void _doCancel() {
    CusDialog.normal(context, title: "确定取消该订单吗?", onApproval: () async {
      try {
        bool ok = await ApiBBSPrize.bbsPrizeCancel(widget.data.id);
        if (ok) {
          Debug.log("取消订单结果：$ok");
          CusToast.toast(context, text: "取消成功");
          if (widget.onChanged != null) {
            widget.onChanged();
          }
        }
      } catch (e) {
        Debug.logError("取消订单出现异常：$e");
      }
    });
  }

  /// 支付订单
  void _doPay() async {
    var data = PayData(
      amt: widget.data.amt,
      b_type: b_bbs_prize,
      id: widget.data.id,
    );
    BalancePay(context, data: data);
  }

  /// 该页面通用按钮
  Widget _comBtnCtr(String text, {VoidCallback onPressed}) {
    return CusRaisedBtn(
      text: text,
      fontSize: 26,
      pdHor: 24,
      pdVer: 5,
      backgroundColor: primary,
      borderRadius: 100,
      onPressed: onPressed ?? () {},
    );
  }
}
