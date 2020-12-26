import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 下午7:27
// usage ：大师订单输入框
// ------------------------------------------------------

class YiOrderInput extends StatefulWidget {
  final YiOrder yiOrder;
  final bool needCh; //  是否修改测算结果
  final VoidCallback onSend;

  YiOrderInput({this.yiOrder, this.onSend, this.needCh: false, Key key})
      : super(key: key);

  @override
  _YiOrderInputState createState() => _YiOrderInputState();
}

class _YiOrderInputState extends State<YiOrderInput> {
  var _replyCtrl = TextEditingController();
  var _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return _row();
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Container(child: _input(), color: Colors.grey),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: t_yi,
            child: FlatButton(
              onPressed: _doReply,
              child: Text(
                "发送",
                style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
              ),
              padding: EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }

  /// 回复订单
  void _doReply() async {
    if (_replyCtrl.text.isEmpty) {
      CusToast.toast(context, text: "回复内容不能为空");
      return;
    }
    // 设置、修改测算结果
    if ((CusRole.is_master && widget.yiOrder.diagnose.isEmpty) ||
        widget.needCh) {
      Log.info("这是是设置或者修改测算结果");
      _setDiagnose();
      return;
    }
    // 回复大师订单
    try {
      var m = {
        "id_of_order": widget.yiOrder.id,
        "msg_type": msg_text,
        "msg": _replyCtrl.text.trim(),
      };
      Log.info("提交回复大师订单的数据：$m");
      MsgYiOrder msgYiOrder = await ApiMsg.yiOrderMsgSend(m);
      if (msgYiOrder != null) {
        CusToast.toast(context, text: "回复成功");
        _doRefresh();
      }
    } catch (e) {
      Log.error("回复大师订单${widget.yiOrder.id}出现异常：$e");
    }
  }

  /// 设置/修改测算结果
  void _setDiagnose() async {
    try {
      var m = {
        "id": widget.yiOrder.id,
        "diagnose": _replyCtrl.text.trim(),
      };
      bool ok = await ApiYiOrder.yiOrderSetDiagnose(m);
      if (ok) {
        String tip = widget.needCh ? "修改成功" : "设置成功";
        CusToast.toast(context, text: tip);
        _doRefresh();
      }
    } catch (e) {
      Log.error("大师设置测算结果出现异常：$e");
    }
  }

  /// 回复内容输入框
  Widget _input() {
    return LayoutBuilder(
      builder: (context, size) {
        var text = TextSpan(
          text: _replyCtrl.text,
          style: TextStyle(fontSize: S.sp(14)),
        );
        var tp = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        );
        tp.layout(maxWidth: size.maxWidth);
        final int lines = (tp.size.height / tp.preferredLineHeight).ceil();
        return TextField(
          controller: _replyCtrl,
          autofocus: false,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
          maxLines: lines < 8 ? null : 8,
          decoration: InputDecoration(
            hintText: _hintTip,
            hintStyle: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            contentPadding: EdgeInsets.only(left: S.w(10)),
          ),
        );
      },
    );
  }

  /// 根据否有测算结果，动态显示输入框提示信息
  String get _hintTip {
    // 没有测算结果
    if (widget.yiOrder.diagnose.isEmpty) {
      if (CusRole.is_master) return "设置测算结果"; // 设置测算结果
    }
    // 有测算结果
    else {
      // 大师修改测算结果
      if (widget.needCh) {
        _replyCtrl.text = widget.yiOrder.diagnose;
        return "";
      }
      return "回复内容";
    }
    return "回复";
  }

  /// 设置、修改测算结果后，或者发送评论后要刷新的
  void _doRefresh() {
    _replyCtrl.clear();
    _focusNode.unfocus();
    if (widget.onSend != null) widget.onSend();
  }
}
