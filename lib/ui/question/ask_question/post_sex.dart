import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

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
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("您的性别", t_yi, 30),
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
