import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_scroll_actions/cupertinoLeftScroll.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/service/api/api-bbs-prize.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 下午3:36
// usage ：单条回帖的内容
// ------------------------------------------------------

class PostReply extends StatefulWidget {
  final data; // BBSVie、BBSPrize

  PostReply({this.data, Key key}) : super(key: key);

  @override
  _PostReplyState createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  double _localSize = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...List.generate(
          widget.data.master_reply.length,
          (i) => _commentItem(widget.data.master_reply[i], i + 1),
        ),
      ],
    );
  }

  /// 打赏大师
  void _doReward(BBSReply reply) {
    CusDialog.normal(
      context,
      title: "确定给大师 ${reply.nick} 打赏 ${widget.data.amt} $yuan_bao吗",
      onApproval: () async {
        var m = {
          "id": widget.data.id,
          "score": widget.data.amt,
          "master_id": reply.uid,
        };
        try {
          bool ok = await ApiBBSPrize.bbsPrizeDue(m);
          if (ok) {
            Log.info("打赏id为${reply.uid}大师结果:$ok");
            LeftScrollGlobalListener.instance
                .targetStatus(
                  LeftScrollCloseTag("reward_reply"),
                  Key(reply.create_date.toString()),
                )
                .value = true;
            CusToast.toast(context, text: "打赏成功");
          }
        } catch (e) {
          Log.error("打赏id为${reply.uid}大师出现异常：$e");
        }
      },
    );
  }

  /// 单条评论的内容
  Widget _commentItem(e, int level) {
    return Container(
      child: !e.is_master // 根据是否为大师显示打赏功能
          ? CupertinoLeftScroll(
              closeTag: LeftScrollCloseTag("post_reply"),
              key: Key(e.create_date.toString()),
              child: _showReward(e, level),
              buttons: [
                LeftScrollItem(
                  text: "打赏",
                  onTap: () => _doReward(e),
                  color: t_ji,
                ),
              ],
            )
          : _showReward(e, level),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: S.h(5)), // 评论间隔
    );
  }

  /// 根据是否为大师显示打赏功能
  Widget _showReward(BBSReply e, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 评论人头像、昵称、评论时间
        _info(e, level),
        // 评论内容
        Padding(
          padding: EdgeInsets.only(left: Adapt.px(25), bottom: Adapt.px(5)),
          child: Text(
            e.text.first,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(_localSize + 2)),
          ),
        ),
      ],
    );
  }

  /// 评论人头像、昵称、评论时间
  Widget _info(BBSReply e, int level) {
    return ListTile(
      // 评论人头像
      leading: CusAvatar(url: e.icon ?? "", circle: true, size: 45),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // 评论人昵称
          CusText(e.nick.isEmpty ? "唐僧" : e.nick, t_primary, _localSize),
          // 显示帖主标识
          if (!(e.is_master))
            Padding(
              padding: EdgeInsets.only(left: Adapt.px(10)),
              child: e.uid == widget.data.uid
                  ? CusText("(帖主)", Colors.grey, _localSize - 2)
                  : null,
            ),
          Spacer(),
          // 显示层数
          CusText("$level层", Colors.grey, _localSize - 2),
        ],
      ),
      // 评论时间
      subtitle: Padding(
        padding: EdgeInsets.only(top: Adapt.px(10)),
        child: CusText(e.create_date, t_gray, _localSize),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(25)),
      dense: true,
    );
  }
}
