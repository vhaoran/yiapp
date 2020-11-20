import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 10:03
// usage ：我要提问 - 帖子标题
// ------------------------------------------------------

class PostTitleInput extends StatefulWidget {
  final TextEditingController controller;

  PostTitleInput({this.controller, Key key}) : super(key: key);

  @override
  _PostTitleInputState createState() => _PostTitleInputState();
}

class _PostTitleInputState extends State<PostTitleInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: _row(),
    );
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        CusText("帖子标题", t_yi, 30),
        Expanded(
          child: CusRectField(
            controller: widget.controller,
            hintText: "请输入帖子标题",
            fromValue: "我想问一下，金银花喝着怎么样？",
            autofocus: false,
            hideBorder: true,
          ),
        ),
      ],
    );
  }
}
