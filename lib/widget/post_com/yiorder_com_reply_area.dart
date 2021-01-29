import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午3:34
// usage ：大师订单评论区
// ------------------------------------------------------

class YiOrderComReplyArea extends StatefulWidget {
  final List<MsgYiOrder> l;
  final int uid; // 命主的uid

  YiOrderComReplyArea({this.l, this.uid, Key key}) : super(key: key);

  @override
  _YiOrderComReplyAreaState createState() => _YiOrderComReplyAreaState();
}

class _YiOrderComReplyAreaState extends State<YiOrderComReplyArea> {
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
        ...List.generate(
          widget.l.length,
          (i) => Container(
            child: _replyItem(widget.l[i], i + 1),
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
  Widget _replyItem(MsgYiOrder e, int level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 评论人头像、昵称、评论时间、楼层数
        ListTile(
          // 评论人头像
          leading: CusAvatar(url: e.from_icon ?? "", circle: true, size: 45),
          title: _title(e, level),
          // 评论时间
          subtitle: Padding(
            padding: EdgeInsets.only(top: S.h(5)),
            child: Text(
              e.create_date,
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: S.w(12)),
          dense: true,
        ),
        // 评论内容
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
          child: Text(
            e.content,
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        ),
      ],
    );
  }

  Widget _title(MsgYiOrder e, int level) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          e.from_nick, // 评论人昵称
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        if (e.from == widget.uid)
          Text(
            "(命主)",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        Spacer(),
        // 显示层数
        Text("$level楼", style: TextStyle(color: t_gray, fontSize: S.sp(14))),
      ],
    );
  }
}
