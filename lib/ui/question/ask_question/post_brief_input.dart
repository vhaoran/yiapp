import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 10:06
// usage ：我要提问 - 帖子内容
// ------------------------------------------------------

class PostBriefInput extends StatefulWidget {
  final TextEditingController controller;

  PostBriefInput({this.controller, Key key}) : super(key: key);

  @override
  _PostBriefInputState createState() => _PostBriefInputState();
}

class _PostBriefInputState extends State<PostBriefInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Adapt.px(30)),
      padding: EdgeInsets.only(left: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: _input(),
    );
  }

  /// 帖子内容输入框
  Widget _input() {
    return CusRectField(
      controller: widget.controller,
      hintText: "该区域填写您的帖子内容，问题描述的越清晰，详尽，大师们才能更完整、更高质量的为您解答",
      autofocus: false,
      hideBorder: true,
      maxLines: 10,
      pdHor: 0,
    );
  }
}
