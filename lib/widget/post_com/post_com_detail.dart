import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午11:42
// usage ：帖子通用的详情组件，含姓名、性别、出生日期、标题、内容等
// ------------------------------------------------------

class PostComDetail extends StatelessWidget {
  final String tip;
  final String text;

  PostComDetail({this.tip: "", this.text: "", Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Text(
        "$tip:  $text",
        style: TextStyle(color: t_gray, fontSize: S.sp(16)),
      ),
    );
  }
}
