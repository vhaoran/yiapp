import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 09:58
// usage ：我要提问 - 设置悬赏金
// ------------------------------------------------------

class PostScoreInput extends StatefulWidget {
  final TextEditingController controller;

  PostScoreInput({this.controller, Key key}) : super(key: key);

  @override
  _PostScoreInputState createState() => _PostScoreInputState();
}

class _PostScoreInputState extends State<PostScoreInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: _row(),
    );
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        CusText("悬赏金额", t_yi, 30),
        Expanded(
          child: CusRectField(
            controller: widget.controller,
            hintText: "请输入$yuan_bao金额",
            autofocus: false,
            hideBorder: true,
            formatter: true,
          ),
        ),
      ],
    );
  }
}
