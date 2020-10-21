import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 10:53
// usage ：闪断帖，取消、支付、抢单功能
// ------------------------------------------------------

class FlashPayCancel extends StatefulWidget {
  final BBSVie data;
  VoidCallback onChanged; // 取消和支付的回调

  FlashPayCancel({this.data, this.onChanged, Key key}) : super(key: key);

  @override
  _FlashPayCancelState createState() => _FlashPayCancelState();
}

class _FlashPayCancelState extends State<FlashPayCancel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // 发帖时间
        CusText("${CusTime.ymd(widget.data.create_date)}", t_gray, 28),
        Spacer(),
        // 本人帖子，且没有人回复时可以取消帖子
        if (widget.data.uid == ApiBase.uid) ...[
          if (widget.data.reply.isEmpty)
            _comBtnCtr("取消", onPressed: _doCancel), // 取消订单
          if (widget.data.stat == post_no_pay)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
              child: _comBtnCtr("支付", onPressed: _doPay),
            ), // 支付订单
        ],
        // 是大师，并且该单还没有被抢
        if (ApiState.isMaster && widget.data.master_id == 0)
          _comBtnCtr("抢单", onPressed: _doGrab), // 大师抢单
      ],
    );
  }

  /// 取消订单
  void _doCancel() {
    CusDialog.err(context, title: "确定取消该订单吗?", onApproval: () async {
      try {
        bool ok = await ApiBBSVie.bbsVieCancel(widget.data.id);
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

  /// 大师抢单
  void _doGrab() async {
    try {
      BBSVie res = await ApiBBSVie.bbsVieAim(widget.data.id);
      if (res != null) {
        CusToast.toast(context, text: "抢单成功");
      }
    } catch (e) {
      Debug.logError("大师抢单出现异常：$e");
    }
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