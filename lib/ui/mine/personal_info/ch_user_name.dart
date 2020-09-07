import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 17:59
// usage ：修改用户名
// ------------------------------------------------------

class ChUserName extends StatefulWidget {
  final String user_name;

  ChUserName({this.user_name, Key key}) : super(key: key);

  @override
  _ChUserNameState createState() => _ChUserNameState();
}

class _ChUserNameState extends State<ChUserName> {
  String _user_name = "";

  @override
  void initState() {
    _user_name = widget.user_name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "修改昵称"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return DefaultTextStyle(
      style: TextStyle(color: t_primary, fontSize: Adapt.px(30)),
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
            child: Text("昵称"),
          ),
          // 修改昵称输入框
          CusTextField(
              hintText: "输入昵称",
              value: _user_name,
              input: (val) => _user_name = val),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(160)),
            child: Text("限制2-8个字"),
          ),
          CusRaisedBtn(
              text: "修改",
              onPressed: () {
                print(">>>昵称：$_user_name");
              }),
        ],
      ),
    );
  }
}
