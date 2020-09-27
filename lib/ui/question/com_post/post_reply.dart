import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/26 18:04
// usage ：单条回帖的内容
// ------------------------------------------------------

class PostReply extends StatefulWidget {
  final List<BBSReply> l;
  final int uid; // 发帖人的uid

  PostReply({this.l, this.uid, Key key}) : super(key: key);

  @override
  _PostReplyState createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  double _localSize = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...List.generate(widget.l.length, (i) => _item(widget.l[i], i + 1)),
      ],
    );
  }

  Widget _item(BBSReply e, int level) {
    return InkWell(
      onTap: () {
        Debug.log("评论人详情：${e.toJson()}");
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 评论人头像、昵称、评论时间
            _info(e, level),
            // 评论内容
            Padding(
              padding: EdgeInsets.only(left: Adapt.px(15), bottom: Adapt.px(5)),
              child: Text(
                e.text.first,
                style: TextStyle(
                    color: t_gray, fontSize: Adapt.px(_localSize + 2)),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: fif_primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(Adapt.px(10)),
        margin: EdgeInsets.only(bottom: Adapt.px(10)), // 评论间隔
      ),
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
              child: e.uid == widget.uid
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
      contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(5)),
      dense: true,
    );
  }
}
