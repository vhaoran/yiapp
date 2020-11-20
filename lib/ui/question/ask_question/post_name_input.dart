import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 09:24
// usage ：我要提问 - 姓名输入框
// ------------------------------------------------------

class PostNameInput extends StatefulWidget {
  final TextEditingController controller;

  PostNameInput({this.controller, Key key}) : super(key: key);

  @override
  _PostNameInputState createState() => _PostNameInputState();
}

class _PostNameInputState extends State<PostNameInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 10),
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
        CusText("姓名", t_yi, 30),
        Expanded(
          child: CusRectField(
            controller: widget.controller,
            fromValue: "苏醒",
            hintText: "输入您的姓名",
            autofocus: false,
            hideBorder: true,
          ),
        ),
      ],
    );
  }
}
