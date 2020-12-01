import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/msg/msg-notify-his.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/bus/im-bus.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/26 18:17
// usage ：悬赏帖回复评论输入框
// ------------------------------------------------------

class RewardInput extends StatefulWidget {
  final BBSPrize data;
  final VoidCallback onSend;

  RewardInput({this.data, this.onSend, Key key}) : super(key: key);

  @override
  _RewardInputState createState() => _RewardInputState();
}

class _RewardInputState extends State<RewardInput> {
  var _replyCtrl = TextEditingController();
  var _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Container(child: _input(), color: Colors.grey),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: t_yi,
            child: FlatButton(
              onPressed: _doReply,
              child: CusText("发送", Colors.black, 28),
              padding: EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }

  void _doReply() async {
    if (_replyCtrl.text.isEmpty) {
      CusToast.toast(context, text: "请输入回复内容", pos: ToastPos.bottom);
      return;
    }
    var m = {
      "id": widget.data.id,
      "text": [_replyCtrl.text],
    };
    try {
      bool ok = await ApiBBSPrize.bbsPrizeReply(m);
      if (ok) {
        _replyCtrl.clear();
        _focusNode.unfocus();
        CusToast.toast(context, text: "回帖成功");
        glbEventBus.fire(MsgNotifyHis());
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      Log.error("回帖出现异常：$e");
    }
  }

  /// 回复内容输入框
  Widget _input() {
    return TextField(
      controller: _replyCtrl,
      focusNode: _focusNode,
      style: TextStyle(color: Colors.black, fontSize: Adapt.px(28)),
      decoration: InputDecoration(
        hintText: widget.data.reply.isEmpty ? "暂时没有评论，大师们快抢沙发吧" : "回复新楼层",
        hintStyle: TextStyle(color: Colors.black, fontSize: Adapt.px(28)),
        contentPadding: EdgeInsets.only(left: Adapt.px(20)),
      ),
    );
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }
}
