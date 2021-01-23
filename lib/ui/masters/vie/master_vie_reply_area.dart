import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/bbs_reply.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午9:54
// usage ：大师闪断帖评论区
// ------------------------------------------------------

class MasterVieReplyArea extends StatefulWidget {
  final BBSVie vie;

  MasterVieReplyArea({this.vie, Key key}) : super(key: key);

  @override
  _MasterVieReplyAreaState createState() => _MasterVieReplyAreaState();
}

class _MasterVieReplyAreaState extends State<MasterVieReplyArea> {
  @override
  Widget build(BuildContext context) {
    return _replyView();
  }

  /// 闪断帖评论区域
  Widget _replyView() {
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
        ...List.generate(
          widget.vie.reply.length,
          (i) => Container(
            child: _replyItem(widget.vie.reply[i], i + 1),
            decoration: BoxDecoration(
              color: fif_primary,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(bottom: S.h(5)), // 评论间隔
          ),
        ),
      ],
    );
  }

  /// 单条评论的数据
  Widget _replyItem(BBSReply reply, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 评论人头像、昵称、评论时间、楼层数
        ListTile(
          // 评论人头像
          leading: CusAvatar(url: reply.icon ?? "", circle: true, size: 45),
          title: _title(reply, level),
          // 评论时间
          subtitle: Padding(
            padding: EdgeInsets.only(top: S.h(5)),
            child: Text(
              reply.create_date,
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: S.w(12)),
          dense: true,
        ),
        // 评论内容
        ...reply.text.map(
          (m) => Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Text(
              m,
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _title(BBSReply e, int level) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          e.nick, // 评论人昵称
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        // 显示帖主标识
        if (e.uid == widget.vie.uid)
          Padding(
            padding: EdgeInsets.only(left: S.h(5)),
            child: Text(
              "(帖主)",
              style: TextStyle(color: t_gray, fontSize: S.sp(14)),
            ),
          ),
        Spacer(),
        // 显示层数
        Text("$level楼", style: TextStyle(color: t_gray, fontSize: S.sp(14))),
      ],
    );
  }
}
