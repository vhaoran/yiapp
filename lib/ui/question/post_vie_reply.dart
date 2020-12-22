import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 下午3:36
// usage ：闪断帖回帖的内容
// ------------------------------------------------------

class PostVieReply extends StatefulWidget {
  final BBSVie data;
  final VoidCallback onSuccess;

  PostVieReply({this.data, this.onSuccess, Key key}) : super(key: key);

  @override
  _PostVieReplyState createState() => _PostVieReplyState();
}

class _PostVieReplyState extends State<PostVieReply> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...List.generate(
          widget.data.reply.length,
          (i) => _commentItem(widget.data.reply[i], i + 1),
        ),
      ],
    );
  }

  /// 单条评论的内容
  Widget _commentItem(BBSReply e, int level) {
    Widget child;
    // 如果当前是大师的评论，且是发帖人，则可以看到打赏按钮
    if (e.is_master &&
        widget.data.uid == ApiBase.uid &&
        widget.data.stat == bbs_paid) {
      child = CupertinoLeftScroll(
        closeTag: LeftScrollCloseTag("vie_reply"),
        key: Key(e.create_date.toString()),
        child: _item(e, level),
        buttons: [
          LeftScrollItem(
            text: "打赏",
            onTap: () => _doReward(e),
            color: t_red,
          ),
        ],
      );
    } else {
      child = _item(e, level);
    }
    return Container(
      child: child,
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: S.h(5)), // 评论间隔
    );
  }

  /// 单条评论的数据
  Widget _item(BBSReply e, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 评论人头像、昵称、评论时间、楼层数
        _commentInfo(e, level),
        // 评论内容
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Text(
            e.text.first,
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        ),
      ],
    );
  }

  /// 评论人头像、昵称、评论时间
  Widget _commentInfo(BBSReply e, int level) {
    var subtitle = Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Text(
        e.create_date,
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      ),
    );
    return ListTile(
      // 评论人头像
      leading: CusAvatar(url: e.icon ?? "", circle: true, size: 45),
      title: _title(e, level),
      // 评论时间
      subtitle: subtitle,
      contentPadding: EdgeInsets.symmetric(horizontal: S.w(12)),
      dense: true,
    );
  }

  Widget _title(BBSReply e, int level) {
    var style = TextStyle(color: t_gray, fontSize: S.sp(14));
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          e.nick, // 评论人昵称
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        // 显示帖主标识
        Padding(
          padding: EdgeInsets.only(left: S.h(5)),
          child: e.uid == widget.data.uid ? Text("(帖主)", style: style) : null,
        ),
        Spacer(),
        // 显示层数
        Text("$level楼", style: style),
      ],
    );
  }

  /// 打赏大师
  void _doReward(BBSReply reply) {
    CusDialog.normal(
      context,
      title: "确定给大师【${reply.nick}】打赏${widget.data.amt}$yuan_bao吗",
      onApproval: () async {
        var m = {
          "id": widget.data.id,
          "score": widget.data.amt,
          "master_id": reply.uid,
        };
        try {
          bool ok = await ApiBBSVie.bbsVieDue(m);
          if (ok) {
            Log.info("给大师 ${reply.uid} 打赏的结果:$ok");
            CusToast.toast(context, text: "打赏成功");
            CusRoute.pushReplacement(context, HomePage());
            if (widget.onSuccess != null) widget.onSuccess();
            LeftScrollGlobalListener.instance
                ?.targetStatus(
                  LeftScrollCloseTag("vie_reply"),
                  Key(reply.create_date.toString()),
                )
                ?.value = true;
          }
        } catch (e) {
          Log.error("打赏id为${reply.uid}大师出现异常：$e");
        }
      },
    );
  }
}
