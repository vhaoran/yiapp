import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';
import 'post_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/25 11:27
// usage ：显示所有的评论回复
// ------------------------------------------------------

class AllReply extends StatefulWidget {
  final List<BBSReply> l;
  final int level;

  AllReply({this.l, this.level, Key key}) : super(key: key);

  @override
  _AllReplyState createState() => _AllReplyState();
}

class _AllReplyState extends State<AllReply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "评论 ${widget.l.length}"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
      children: <Widget>[
        PostReply(l: widget.l, showAll: true, level: widget.level), // 回复帖子区域
        Container(
          color: fif_primary,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.all(Adapt.px(20)),
          child: CusText("- 我是有底线的 -", Colors.grey, 28),
        ),
      ],
    );
  }
}
