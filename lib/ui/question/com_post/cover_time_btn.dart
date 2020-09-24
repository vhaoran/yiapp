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

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/24 17:35
// usage ：帖子封面中的时间、取消和支付按钮
// ------------------------------------------------------

class CoverTimeBtn extends StatefulWidget {
  final BBSPrize data;
  final bool show;
  VoidCallback onChanged; // 取消和支付的回调

  CoverTimeBtn({
    this.data,
    this.show,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _CoverTimeBtnState createState() => _CoverTimeBtnState();
}

class _CoverTimeBtnState extends State<CoverTimeBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // 发帖时间
        CusText("${CusTime.ymd(widget.data.create_date)}", t_gray, 28),
        Spacer(),
        if (widget.show) ...[
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
