import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/ui/question/reply_more.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午8:33
// usage ：大师可抢单的悬赏帖评论区
// ------------------------------------------------------

class MasterPrizeAimReplyArea extends StatefulWidget {
  final BBSPrize prize;

  MasterPrizeAimReplyArea({this.prize, Key key}) : super(key: key);

  @override
  _MasterPrizeAimReplyAreaState createState() =>
      _MasterPrizeAimReplyAreaState();
}

class _MasterPrizeAimReplyAreaState extends State<MasterPrizeAimReplyArea> {
  final int _showMax = 4;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          alignment: Alignment.center,
          child: Text(
            "评论区",
            style: TextStyle(color: t_primary, fontSize: S.sp(16)),
          ),
        ),
        // 评论详情
        ...List.generate(
          widget.prize.master_reply.length,
          (i) => _commentItem(widget.prize.master_reply[i], i + 1),
        )
      ],
    );
  }

  /// 单条评论的内容
  Widget _commentItem(BBSPrizeReply reply, int level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: S.h(10)), // 评论间隔
      child: Column(
        children: <Widget>[
          _masterInfo(reply, level), // 大师头像、昵称、评论时间、所处楼层数
          SizedBox(height: S.h(5)),
          // 评论长度不大于4时，显示全部评论
          if (reply.reply.length <= _showMax)
            ...List.generate(
              reply.reply.length,
              (index) => _commentDetail(reply.reply[index], reply),
            ),
          // 评论长度大于4时，显示查看更多评论按钮
          if (reply.reply.length > _showMax) ...[
            ...List.generate(
              _showMax,
              (index) => _commentDetail(reply.reply[index], reply),
            ),
            InkWell(
              onTap: () {
                CusRoute.push(
                  context,
                  PrizeReplyMore(
                      reply: reply, nick: widget.prize.nick, level: level),
                );
              },
              child: Text(
                "还有${reply.reply.length - _showMax}条回复...",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
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
        CusAvatar(url: e?.master_icon ?? "", circle: true, size: 45),
        SizedBox(width: S.w(15)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(e?.master_nick ?? "", style: primary), // 大师昵称
                  // 大师获得的悬赏金，没被打赏时不显示
                  if (e.amt != 0) Text("被打赏${e.amt}元宝", style: primary),
                  Text("$level楼", style: gray), // 大师所处楼层数
                ],
              ),
              SizedBox(height: S.h(5)),
              Text(e.reply.first.create_date, style: gray), // 大师第一条评论的时间
            ],
          ),
        ),
      ],
    );
  }

  /// 相互评论的详情，这里all中的master_nick和r中nick有时不一致，以all为主
  Widget _commentDetail(BBSReply r, BBSPrizeReply all) {
    TextStyle blue = TextStyle(color: Colors.lightBlue, fontSize: S.sp(15));
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Container(
      color: Colors.black12, // 单条评论背景色
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      margin: EdgeInsets.symmetric(vertical: S.h(2)), // 同一层评论间隔
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 大师给帖主的回复
              if (r.is_master) ...[
                Text("${all.master_nick}", style: blue), // 大师昵称
                Text("►", style: gray),
                Text("${widget.prize.nick}", style: blue), // 帖主昵称
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
}
