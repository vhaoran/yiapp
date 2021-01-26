import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
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
  // 用户选择大师进行回复，大师不需要这个
  final BBSPrizeReply userSelectReply;
  final VoidCallback onSend;

  PostInput({this.post, this.userSelectReply, this.onSend, Key key})
      : super(key: key);

  @override
  _PostInputState createState() => _PostInputState();
}

class _PostInputState extends State<PostInput> {
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
          autofocus: false,
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

  /// 根据不同的身份，输入框显示不同的默认内容
  String _hintTip(List l) {
    if (l.isEmpty) return "暂无评论，快抢沙发吧";
    if (CusRole.is_master) return "回复帖主";
    // 如果是悬赏帖
    if (!widget.post.is_vie && widget.userSelectReply != null) {
      return "回复：${widget.userSelectReply.master_nick}";
    }
    if (widget.post.is_vie) return "回复大师";
    return "选择大师进行回复";
  }

  /// 回复悬赏帖或者闪断帖
  void _doReply() async {
    if (_replyCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "请输入回复内容");
      return;
    }
    int masterId = 0;
    // 如果是大师回复，不需要区分帖子类别，回复的是自己
    if (CusRole.is_master)
      masterId = ApiBase.uid;
    // 如果是用户回复悬赏帖，则回复的是选择的大师
    else if (!widget.post.is_vie) {
      masterId = widget.userSelectReply?.master_id;
      if (masterId == null) {
        CusToast.toast(context, text: "请先选择一位大师，再进行回复");
        return;
      }
    }
    // 如果是用户回复闪断帖，则回复的是当前帖子的 master_id
    else if (widget.post.is_vie) masterId = widget.post.data.masterId;
    var m = {
      "id": widget.post.data.id,
      "to_master": masterId,
      "text": [_replyCtrl.text.trim()],
    };
    Log.info("回帖时要提交的数据：$m");
    setState(() => _isSending = true);
    try {
      bool ok = widget.post.is_vie
          ? await ApiBBSVie.bbsVieReply(m)
          : await ApiBBSPrize.bbsPrizeReply(m);
      if (ok) {
        _isSending = false;
        _replyCtrl.clear();
        _focusNode.unfocus();
        CusToast.toast(context, text: "回帖成功");
        setState(() {});
        if (widget.onSend != null) widget.onSend();
      }
    } catch (e) {
      _isSending = false;
      setState(() {});
      Log.error("回帖出现异常：$e");
    }
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }
}
