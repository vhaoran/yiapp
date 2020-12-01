import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 09:52
// usage ：我要提问 - 选择性别
// ------------------------------------------------------

class PostSexCtr extends StatefulWidget {
  FnInt onChanged;

  PostSexCtr({this.onChanged, Key key}) : super(key: key);

  @override
  _PostSexCtrState createState() => _PostSexCtrState();
}

class _PostSexCtrState extends State<PostSexCtr> {
  int _male = 1; // 性别

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("性别", t_yi, 30),
          _selectCtr(male, "男"),
          _selectCtr(female, "女"),
        ],
      ),
    );
  }

  Widget _selectCtr(int value, String text) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _male,
          activeColor: t_gray,
          focusColor: value == 0 ? Colors.red : Colors.green,
          hoverColor: Colors.blue,
          onChanged: (val) {
            if (val != null) setState(() => _male = val);
            if (widget.onChanged != null) widget.onChanged(val);
          },
        ),
        CusText(text, t_gray, 28),
      ],
    );
  }
}
