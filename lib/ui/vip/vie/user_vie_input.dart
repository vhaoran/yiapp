import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 上午9:44
// usage ：会员回复闪断帖
// ------------------------------------------------------

class UserVieInput extends StatefulWidget {
  final BBSVie vie;
  final VoidCallback onSend;

  UserVieInput({this.vie, this.onSend, Key key}) : super(key: key);

  @override
  _UserVieInputState createState() => _UserVieInputState();
}

class _UserVieInputState extends State<UserVieInput> {
  var _replyCtrl = TextEditingController();
  var _focusNode = FocusNode();
  bool _isSending = false; // 是否正在发送

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(child: _input(), color: Colors.grey),
        ),
        _sendMsgWt(),
      ],
    );
  }

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
            hintText: _hintText(),
            hintStyle: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            contentPadding: EdgeInsets.only(left: S.w(10)),
          ),
        );
      },
    );
  }

  Widget _sendMsgWt() {
    return Container(
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
    );
  }

  /// 选择大师后，发送评论
  void _doReply() async {
    if (widget.vie.reply.isEmpty) {
      CusToast.toast(context, text: "有大师回帖后帖主才可以评论");
      return;
    }
    if (_replyCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "请输入回复内容");
      return;
    }
    var m = {
      "id": widget.vie.id,
      "text": [_replyCtrl.text.trim()],
    };
    Log.info("会员回复闪断帖的数据：$m");
    setState(() => _isSending = true);
    try {
      bool ok = await ApiBBSVie.bbsVieReply(m);
      if (ok) {
        _isSending = false;
        _replyCtrl.clear();
        _focusNode.unfocus();
        CusToast.toast(context, text: "发送成功");
        setState(() {});
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      _isSending = false;
      setState(() {});
      Log.error("会员回复闪断帖出现异常：$e");
    }
  }

  String _hintText() {
    if (widget.vie.reply.isEmpty) {
      return "有大师回帖后帖主才可以评论";
    }
    return "回复：${widget.vie.master_nick}";
  }
}
