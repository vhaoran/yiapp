import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/14 下午5:23
// usage ：大师控制台
// ------------------------------------------------------

class MasterConsole extends StatefulWidget {
  MasterConsole({Key key}) : super(key: key);

  @override
  _MasterConsoleState createState() => _MasterConsoleState();
}

class _MasterConsoleState extends State<MasterConsole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "测试"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }
}
