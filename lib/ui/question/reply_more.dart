import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/22 上午9:23
// usage ：查看更多评论，针对悬赏帖
// ------------------------------------------------------

class PrizeReplyMore extends StatelessWidget {
  final BBSPrizeReply reply;
  final String nick; // 帖主名字
  final int level; // 大师评论所处楼层数

  PrizeReplyMore({this.reply, this.nick: "", this.level: 10, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "评论:${reply.reply.length}"),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: ListView(
          children: <Widget>[
            _commentItem(reply, level),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: S.h(10)),
              child: Text(
                "- 我是有底线的 -",
                style: TextStyle(color: Colors.yellow),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: primary,
    );
  }

  /// 单条评论的内容
  Widget _commentItem(BBSPrizeReply rep, int level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          _masterInfo(rep, level), // 大师头像、昵称、评论时间、所处楼层数
          SizedBox(height: S.h(5)),
          ...List.generate(
            rep.reply.length,
            (index) => _commentDetail(rep.reply[index], rep),
          ),
        ],
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

  /// 相互评论的详情，这里all中的master_nick和r中nick有时不一致，以all为主
  Widget _commentDetail(BBSReply r, BBSPrizeReply all) {
    TextStyle blue = TextStyle(color: Colors.lightBlue, fontSize: S.sp(15));
    TextStyle gray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Container(
      color: Colors.black12, // 单条评论背景色
      padding: EdgeInsets.symmetric(horizontal: S.w(10), vertical: S.h(5)),
      margin: EdgeInsets.symmetric(vertical: S.h(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              // 大师给帖主的回复
              if (r.is_master) ...[
                Text("${all.master_nick}", style: blue), // 大师昵称
                Text("►", style: gray),
                Text(nick, style: blue), // 帖主昵称
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
          Text(r.text.first, style: gray), // 回复的内容
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
