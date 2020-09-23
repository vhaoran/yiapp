import 'package:flutter/material.dart';
import 'package:yiapp/model/bbs/bbs-Reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 17:47
// usage ：单条回帖的内容
// ------------------------------------------------------

class PostReply extends StatefulWidget {
  BBSReply reply;

  PostReply({this.reply, Key key}) : super(key: key);

  @override
  _PostReplyState createState() => _PostReplyState();
}

class _PostReplyState extends State<PostReply> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
