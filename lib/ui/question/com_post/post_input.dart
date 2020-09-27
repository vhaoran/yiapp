import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/msg/msg_body.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/ui/question/com_post/post_event.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/26 18:17
// usage ：回复帖子输入框
// ------------------------------------------------------

class PostInput extends StatefulWidget {
  final BBSPrize data;
  final VoidCallback onSend;

  PostInput({this.data, this.onSend, Key key}) : super(key: key);

  @override
  _PostInputState createState() => _PostInputState();
}

class _PostInputState extends State<PostInput> {
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
        glbEventBus.fire(MsgBody(content_type: "comment"));
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      Debug.logError("回帖出现异常：$e");
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
