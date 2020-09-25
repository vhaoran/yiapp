import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/25 10:16
// usage ：帖子单条评论组件
// ------------------------------------------------------

class ReplyItem extends StatefulWidget {
  final BBSReply data;

  ReplyItem({this.data, Key key}) : super(key: key);

  @override
  _ReplyItemState createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Debug.log("评论人uid:${widget.data.uid}");
      },
      child: Container(
        color: fif_primary,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: Adapt.px(20), vertical: Adapt.px(15)),
        margin: EdgeInsets.only(bottom: Adapt.px(5)), // 评论间隔
        child: _co(),
      ),
    );
  }

  /// 评论详情
  Widget _co() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CusText("${widget.data.nick}", Color(0xFF4D95E4), 28), // 评论人昵称
            if (!(widget.data.is_master))
              CusText("(帖主)", Colors.grey, 26), // 是帖主，显示标识
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          child: Text(
            widget.data.text.first, // 评论内容
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: CusText(widget.data.create_date, Colors.grey, 26),
        ), // 评论时间
      ],
    );
  }
}
