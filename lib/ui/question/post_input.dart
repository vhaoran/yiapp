import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 下午3:06
// usage ：回帖评论输入框
// ------------------------------------------------------

class PostInput extends StatefulWidget {
  final Post post;
  final BBSReply reply;
  final VoidCallback onSend;

  PostInput({this.post, this.reply, this.onSend, Key key}) : super(key: key);

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

  /// 回复内容输入框
  Widget _input() {
    List l = widget.post.is_vie
        ? widget.post.data.reply
        : widget.post.data.master_reply;
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
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
          maxLines: lines < 8 ? null : 8,
          decoration: InputDecoration(
            hintText: _hintTip(l),
            hintStyle: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            contentPadding: EdgeInsets.only(left: S.w(10)),
          ),
        );
      },
    );
  }

  String _hintTip(List l) {
    if (l.isEmpty) return "暂无评论，快抢沙发吧";
    if (widget.reply != null) return "回复：${widget.reply.nick}";
    return "点就大师评论进行回复";
  }

  /// 回复悬赏帖或者闪断帖
  void _doReply() async {
    if (_replyCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "请输入回复内容");
      return;
    }
    return;
    var m = {
      "id": widget.post.data.id,
      "master_id": widget.reply.uid,
      "amt": 1, // 打赏金额，先为1
      "text": [_replyCtrl.text.trim()],
    };
    try {
      bool ok = widget.post.is_vie
          ? await ApiBBSVie.bbsVieReply(m)
          : await ApiBBSPrize.bbsPrizeReply(m);
      if (ok) {
        _replyCtrl.clear();
        _focusNode.unfocus();
        CusToast.toast(context, text: "回帖成功");
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      Log.error("回帖出现异常：$e");
    }
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }
}
