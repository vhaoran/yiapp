import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/balance_pay.dart';
import 'package:yiapp/model/pays/order_pay_data.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 下午3:14
// usage ：帖子的取消和支付按钮
// ------------------------------------------------------

class PostPayCancel extends StatefulWidget {
  final bool isVie;
  final data;
  final VoidCallback onChanged; // 取消和支付的回调

  PostPayCancel({this.data, this.isVie: false, this.onChanged, Key key})
      : super(key: key);

  @override
  _PostPayCancelState createState() => _PostPayCancelState();
}

class _PostPayCancelState extends State<PostPayCancel> {
  var _p;

  @override
  void initState() {
    _p = PayData(amt: widget.data.amt, b_type: b_bbs_prize, id: widget.data.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(5)),
      child: _row(),
    );
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        Text(
          "${TimeUtil.parseYMD(widget.data.create_date)}", // 发帖时间
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        Spacer(),
        // 状态为待付款，且本人帖子
        if (widget.data.stat == pay_await &&
            widget.data.uid == ApiBase.uid) ...[
          // 没有人回复时显示取消按钮
          if (widget.data.reply.isEmpty)
            _comBtn(text: "取消", onPressed: _doCancel), // 取消订单
          SizedBox(width: S.w(5)),
          _comBtn(
            text: "支付", // 支付订单
            onPressed: () => BalancePay(context, data: _p),
          ),
        ],
        // 状态为已付款，是大师，并且该单没有被抢
        if (widget.isVie &&
            widget.data.stat == pay_paid &&
            (CusRole.is_master && widget.data.master_id == 0))
          _comBtn(text: "抢单", onPressed: _doRob),
      ],
    );
  }

  /// 抢单
  void _doRob() async {
    Log.info("抢单 id :${widget.data.id}");
    try {
      BBSVie res = await ApiBBSVie.bbsVieAim(widget.data.id);
      if (res != null) CusToast.toast(context, text: "抢单成功");
    } catch (e) {
      Log.error("大师抢单出现异常：$e");
    }
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
        borderRadius: 50,
        backgroundColor: primary,
      ),
    );
  }
}
