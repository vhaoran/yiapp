import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/service/api/api_msg.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 下午2:15
// usage ：大师大师订单输入框
// ------------------------------------------------------

class MasterYiOrderInput extends StatefulWidget {
  final YiOrder yiOrder;
  final VoidCallback onSend;

  MasterYiOrderInput({this.yiOrder, this.onSend, Key key})
      : super(key: key);

  @override
  _MasterYiOrderInputState createState() => _MasterYiOrderInputState();
}

class _MasterYiOrderInputState extends State<MasterYiOrderInput> {
  var _replyCtrl = TextEditingController();
  var _focusNode = FocusNode();
  bool _isSending = false; // 是否正在发送

  @override
  Widget build(BuildContext context) {
    return _userInputWt();
  }

  Widget _userInputWt() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(child: _inputWt(), color: Colors.grey),
        ),
        Container(
          color: t_yi,
          child: FlatButton(
            onPressed: _isSending ? null : _doReply,
            child: Row(
              children: <Widget>[
                if (_isSending) ...[
                  SizedBox(
                    height: S.h(20),
                    width: S.w(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: S.w(5)),
                ],
                Text(
                  "发送",
                  style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
                ),
              ],
            ),
            padding: EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }

  /// 回复订单
  void _doReply() async {
    if (_replyCtrl.text.isEmpty) {
      CusToast.toast(context, text: "请输入内容");
      return;
    }
    if (widget.yiOrder.diagnose.isEmpty) {
      CusToast.toast(context, text: "请设置测算结果后再回复");
      return;
    }
    var m = {
      "id_of_order": widget.yiOrder.id,
      "msg_type": msg_text,
      "msg": _replyCtrl.text.trim(),
    };
    Log.info("大师回复大师订单的数据 $m");
    setState(() => _isSending = true);
    try {
      MsgYiOrder msgYiOrder = await ApiMsg.yiOrderMsgSend(m);
      if (msgYiOrder != null) {
        _isSending = false;
        CusToast.toast(context, text: "回复成功");
        _replyCtrl.clear();
        _focusNode.unfocus();
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      _isSending = false;
      Log.error("大师回复大师订单 ${widget.yiOrder.id} 出现异常：$e");
    }
  }

  /// 回复内容输入框
  Widget _inputWt() {
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
            hintText: "回复命主",
            hintStyle: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            contentPadding: EdgeInsets.only(left: S.w(10)),
          ),
        );
      },
    );
  }
}
