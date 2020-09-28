import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/api/api_base.dart';

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
        // 发帖时间
        CusText("${CusTime.ymd(widget.data.create_date)}", t_gray, 28),
        Spacer(),
        if (widget.data.uid == ApiBase.uid) ...[
          // 本人帖子，且没有人回复时可以取消帖子
          if (widget.data.reply.isEmpty)
            CusRaisedBtn(
              text: "取消",
              fontSize: 26,
              pdHor: 24,
              pdVer: 5,
              backgroundColor: primary,
              borderRadius: 100,
              onPressed: _doCancel, // 取消订单
            ),
          SizedBox(width: Adapt.px(20)),
          // 订单未支付
          if (widget.data.stat == 0)
            CusRaisedBtn(
              text: "支付",
              fontSize: 26,
              pdHor: 24,
              pdVer: 5,
              backgroundColor: primary,
              borderRadius: 100,
              onPressed: _doPay, // 支付订单
            ),
        ],
      ],
    );
  }

  /// 取消订单
  void _doCancel() {
    CusDialog.err(context, title: "确定取消该订单吗?", onApproval: () async {
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
    Debug.log("支付订单");
  }
}
