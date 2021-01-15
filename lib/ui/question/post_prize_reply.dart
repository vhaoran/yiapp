import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/model/complex/post_trans.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/question/reply_more.dart';
import 'package:yiapp/ui/question/reward_input.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
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
  final Post post;
  final bool overBtn;
  final FnBBSReply fnBBSReply;
  final VoidCallback onReward; // 用户打赏大师后的回调

  PostPrizeReply({
    this.data,
    this.post,
    this.overBtn: false,
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
    return CusRole.is_master && widget.post.is_ing
        ? _selfMasterComment() // 大师查看处理中的悬赏帖
        : Column(
            children: <Widget>[
              ...List.generate(
                widget.data.master_reply.length,
                (i) => _commentItem(widget.data.master_reply[i], i + 1),
              )
            ],
          );
  }

  /// 如果是大师，且状态为处理中，则看到的处理中的悬赏帖评论是只有他自己和帖主的回复
  Widget _selfMasterComment() {
    BBSPrizeReply r = widget.data.master_reply.singleWhere(
      (e) => e.master_id == ApiBase.uid,
      orElse: () => null,
    );
    // 说明自己还未给当前帖子回复
    if (r != null) {
      int level = widget.data.master_reply.indexOf(r);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
        decoration: BoxDecoration(
          color: fif_primary,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(bottom: S.h(10)), // 评论间隔
        child: Column(
          children: <Widget>[
            _masterInfo(r, level), // 大师头像、昵称、评论时间、所处楼层数
            ...List.generate(
              r.reply.length,
              (index) => _commentDetail(r.reply[index], r),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  /// 单条评论的内容
  Widget _commentItem(BBSPrizeReply rep, int level) {
    return InkWell(
      onTap: () {
        Log.info("当前楼层的详情：${rep.toJson()}");
        if (widget.fnBBSReply != null) widget.fnBBSReply(rep);
      },
      child: Container(
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
            // 评论长度不大于4时，或者是大师，则显示全部评论
            if (rep.reply.length <= max)
              ...List.generate(
                rep.reply.length,
                (index) => _commentDetail(rep.reply[index], rep),
              ),
            // 评论长度大于4时，且不是大师时，显示查看更多评论按钮
            if (rep.reply.length > max) ...[
              ...List.generate(
                4,
                (index) => _commentDetail(rep.reply[index], rep),
              ),
              InkWell(
                onTap: () {
                  int level = widget.data.master_reply.indexOf(rep) + 1;
                  CusRoute.push(
                    context,
                    ReplyMore(reply: rep, nick: widget.data.nick, level: level),
                  );
                },
                child: Text(
                  "还有${rep.reply.length - max}条回复...",
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 相互评论的详情，这里all中的master_nick和r中nick有时不一致，以all为主
  Widget _commentDetail(BBSReply r, BBSPrizeReply all) {
    TextStyle blue = TextStyle(color: Colors.lightBlue, fontSize: S.sp(15));
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Container(
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
              if (!r.is_master) Text("${r.nick}", style: blue), // 帖主昵称
              Text(
                "（帖主）",
                style: TextStyle(color: t_gray, fontSize: S.sp(13)),
              ),
            ],
          ),
          SizedBox(height: S.h(5)),
          ...r.text.map((e) => Text(e, style: gray)), // 回复的内容
          SizedBox(height: S.h(5)),
          Container(
            alignment: Alignment.centerRight,
            child: Text(r.create_date, style: gray), // 回复的时间
          ),
        ],
      ),
    );
  }

  /// 大师头像、昵称、评论时间、所处楼层数
  Widget _masterInfo(BBSPrizeReply e, int level) {
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    TextStyle primary = TextStyle(color: t_primary, fontSize: S.sp(15));
    return Row(
      children: <Widget>[
        CusAvatar(url: e.master_icon ?? "", circle: true, size: 45),
        SizedBox(width: S.w(15)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(e.master_nick, style: primary), // 大师昵称
                  // 大师获得的悬赏金，没被打赏时不显示
                  if (e.amt != 0) Text("被打赏${e.amt}元宝", style: primary),
                  Text("$level楼", style: gray), // 大师所处楼层数
                ],
              ),
              SizedBox(height: S.h(5)),
              Row(
                children: <Widget>[
                  Text(e.reply.first.create_date, style: gray), // 大师第一条评论的时间
                  // 如果是发帖人，且有大师评论，大师还未被打赏时，则显示打赏按钮
                  if (widget.data.uid == ApiBase.uid &&
                      !widget.overBtn &&
                      e.amt == 0) ...[
                    Spacer(),
                    CusRaisedButton(
                      padding: EdgeInsets.symmetric(
                        horizontal: S.w(10),
                        vertical: S.h(3),
                      ),
                      child: Text("打赏"),
                      onPressed: () => CusRoute.push(
                        context,
                        RewardInput(data: widget.data, reply: e),
                      ).then((value) {
                        if (value != null) widget.onReward();
                      }),
                      borderRadius: 50,
                      textColor: Colors.black,
                      backgroundColor: t_primary,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
