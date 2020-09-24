import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
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
  BBSPrize _data; // 帖子详情

  @override
  void initState() {
    _data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "问题详情"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      children: <Widget>[
        PostHeader(data: _data), // 帖子头部信息
        PostReply(l: _data.reply), // 回复帖子区域
      ],
    );
  }
}
