import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/ui/question/com_post/post_header.dart';
import 'package:yiapp/ui/question/com_post/post_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 14:56
// usage ：帖子内容组件
// ------------------------------------------------------

class PostContent extends StatefulWidget {
  final BBSPrize data;

  PostContent({this.data, Key key}) : super(key: key);

  @override
  _PostContentState createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
              children: <Widget>[
                PostHeader(data: widget.data), // 帖子头部信息
                ...List.generate(
                  3, // 回复帖子区域，该处为模拟数据
                  (i) => PostReply(l: widget.data.reply, level: i + 1),
                ),
              ],
            ),
          ),
          _input(),
        ],
      ),
      backgroundColor: primary,
    );
  }

  ///  回复评论输入框
  Widget _input() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 9,
          child: Container(
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: Adapt.px(28)),
              decoration: InputDecoration(
                hintText: "回复内容...",
                hintStyle:
                    TextStyle(color: Colors.black, fontSize: Adapt.px(28)),
                contentPadding: EdgeInsets.only(left: Adapt.px(20)),
              ),
            ),
            color: Colors.grey,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: t_yi,
            child: FlatButton(
              onPressed: () {},
              child: CusText("发送", Colors.black, 28),
              padding: EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }
}
