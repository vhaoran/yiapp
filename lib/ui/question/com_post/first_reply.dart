import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/25 11:12
// usage ：第一条评论(大师的)
// ------------------------------------------------------

class FirstReply extends StatefulWidget {
  final BBSReply data;
  final int level; // 几楼

  FirstReply({this.data, this.level, Key key}) : super(key: key);

  @override
  _FirstReplyState createState() => _FirstReplyState();
}

class _FirstReplyState extends State<FirstReply> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _infoCtr(), // 大师第一条评论中的头像、昵称、评论时间
        InkWell(
          onTap: () {},
          child: Text(
            widget.data.text.first, // 大师评论内容
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          ),
        ),
        SizedBox(height: Adapt.px(40)),
      ],
    );
  }

  /// 大师第一条评论中的头像、昵称、评论时间
  Widget _infoCtr() {
    return ListTile(
      leading: CusAvatar(
        url: widget.data.icon ?? "", // 大师头像
        circle: true,
        size: 50,
      ),
      // 大师昵称
      title: Row(
        children: <Widget>[
          CusText("${widget.level}楼", Colors.grey, 26),
          SizedBox(width: Adapt.px(20)),
          CusText(
            widget.data.nick.isEmpty ? "唐僧" : widget.data.nick,
            t_primary,
            28,
          ),
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Adapt.px(10)),
        child: CusText(widget.data.create_date, t_gray, 28), // 大师评论时间
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }
}
