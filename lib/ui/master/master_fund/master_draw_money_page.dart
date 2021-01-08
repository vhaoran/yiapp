import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/6 上午11:13
// usage ：大师提现记录
// ------------------------------------------------------

class MasterDrawMoneyPage extends StatefulWidget {
  MasterDrawMoneyPage({Key key}) : super(key: key);

  @override
  _MasterDrawMoneyPageState createState() => _MasterDrawMoneyPageState();
}

class _MasterDrawMoneyPageState extends State<MasterDrawMoneyPage> {
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
