import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/service/api/api-bbs-vie.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/19 上午11:55
// usage ：悬赏帖回帖的内容
// ------------------------------------------------------

// 用于返回用户选择的哪位大师
typedef FnBBSReply = Function(BBSPrizeReply reply);

class PostPrizeReply extends StatefulWidget {
  final BBSPrize data;
  final FnBBSReply fnBBSReply;
  final VoidCallback onReward; // 用户打赏大师后的回调

  PostPrizeReply({
    this.data,
    this.fnBBSReply,
    this.onReward,
    Key key,
  }) : super(key: key);

  @override
  _PostPrizeReplyState createState() => _PostPrizeReplyState();
}

class _PostPrizeReplyState extends State<PostPrizeReply> {
  final int max = 4; // 最多显示多少条评论

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 是大师，只看自己和帖主的相互评论内容
        if (CusRole.is_master)
          _selfMasterComment(),
        // 用户看到的是自己和所有大师的评论记录
        if (!CusRole.is_master)
          ...List.generate(
            widget.data.master_reply.length,
            (i) => _commentItem(widget.data.master_reply[i], i + 1),
          )
      ],
    );
  }

  /// 如果是大师，则看到的处理中的悬赏帖评论是只有他自己和帖主的回复
  Widget _selfMasterComment() {
    BBSPrizeReply reply =
        widget.data.master_reply.singleWhere((e) => e.master_id == ApiBase.uid);
    int level = widget.data.master_reply.indexOf(reply);
    return _commentItem(reply, level + 1);
  }

  /// 单条评论的内容
  Widget _commentItem(BBSPrizeReply rep, int level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: S.h(10)), // 评论间隔
      child: Column(
        children: <Widget>[
          _masterInfo(rep, level), // 大师头像、昵称、评论时间、所处楼层数
          SizedBox(height: S.h(5)),
          // 评论长度不大于4时，显示全部评论
          if (rep.reply.length <= max)
            ...List.generate(
              rep.reply.length,
              (index) => _commentDetail(rep.reply[index], rep),
            ),
          // 评论长度大于4时，显示查看更多评论按钮
          if (rep.reply.length > max) ...[
            ...List.generate(
              4,
              (index) => _commentDetail(rep.reply[index], rep),
            ),
            Text(
              "还有${rep.reply.length - max}条回复...",
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ],
      ),
    );
  }

  /// 相互评论的详情，这里all中的master_nick和r中nick有时不一致，以all为主
  Widget _commentDetail(BBSReply r, BBSPrizeReply all) {
    TextStyle blue = TextStyle(color: Colors.lightBlue, fontSize: S.sp(15));
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return InkWell(
      onTap: () {
        Log.info("当前评论的详情：${r.toJson()}");
        if (r.is_master && widget.fnBBSReply != null) widget.fnBBSReply(all);
      },
      child: Container(
        color: Colors.black12, // 单条评论背景色
        padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
        margin: EdgeInsets.symmetric(vertical: S.h(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                // 大师给帖主的回复
                if (r.is_master) ...[
                  Text("${all.master_nick}", style: blue), // 大师昵称
                  Text("►", style: gray),
                  Text("${widget.data.nick}", style: blue), // 帖主昵称
                ],
                // 帖主的回复
                if (!r.is_master)
                  Text("${r.nick}", style: blue), // 帖主昵称
                Text(
                  "（帖主）",
                  style: TextStyle(color: t_gray, fontSize: S.sp(13)),
                ),
              ],
            ),
            SizedBox(height: S.h(5)),
            Text(r.text.first, style: gray), // 回复的内容
            SizedBox(height: S.h(5)),
            Container(
              alignment: Alignment.centerRight,
              child: Text(r.create_date, style: gray), // 回复的时间
            ),
          ],
        ),
      ),
    );
  }

  /// 大师头像、昵称、评论时间、所处楼层数
  Widget _masterInfo(BBSPrizeReply e, int level) {
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        CusAvatar(url: e.master_icon ?? "", circle: true, size: 45),
        SizedBox(width: S.w(15)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    e.master_nick, // 大师昵称
                    style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                  ),
                  Spacer(),
                  Text("$level楼", style: style), // 大师所处楼层数
                ],
              ),
              Text(e.reply.first.create_date, style: style) // 大师第一条评论的时间
            ],
          ),
        ),
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
            if (widget.onReward != null) widget.onReward();
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
