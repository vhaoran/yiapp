import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午5:51
// usage ：大师悬赏帖评论区
// ------------------------------------------------------

class MasterPrizeReplyArea extends StatefulWidget {
  final BBSPrize prize;

  MasterPrizeReplyArea({this.prize, Key key}) : super(key: key);

  @override
  _MasterPrizeReplyAreaState createState() => _MasterPrizeReplyAreaState();
}

class _MasterPrizeReplyAreaState extends State<MasterPrizeReplyArea> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          alignment: Alignment.center,
          child: Text(
            "评论区",
            style: TextStyle(color: t_primary, fontSize: S.sp(16)),
          ),
        ),
        _selfMasterComment(),
      ],
    );
  }

  /// 如果是大师，且状态为处理中，则看到的处理中的悬赏帖评论是只有他自己和帖主的回复
  Widget _selfMasterComment() {
    BBSPrizeReply r = widget.prize.master_reply.singleWhere(
      (e) => e.master_id == ApiBase.uid,
      orElse: () => null,
    );
    // 说明自己还未给当前帖子回复
    if (r != null) {
      int level = widget.prize.master_reply.indexOf(r);
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
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
