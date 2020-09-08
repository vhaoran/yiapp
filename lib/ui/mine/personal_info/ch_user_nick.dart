import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 17:59
// usage ：修改用户昵称
// ------------------------------------------------------

class ChUserNick extends StatefulWidget {
  final String nick;

  ChUserNick({this.nick, Key key}) : super(key: key);

  @override
  _ChUserNickState createState() => _ChUserNickState();
}

class _ChUserNickState extends State<ChUserNick> {
  String _nick = "";

  @override
  void initState() {
    _nick = widget.nick;
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
              hintText: "输入昵称", value: _nick, input: (val) => _nick = val),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(130)),
            child: Text("限制2-8个字"),
          ),
          CusRaisedBtn(
              text: "修改",
              onPressed: () {
                print(">>>昵称：$_nick");
              }),
        ],
      ),
    );
  }

  /// 修改昵称
  void _doChNick() async {
    var m = {"nick": _nick};
  }
}
