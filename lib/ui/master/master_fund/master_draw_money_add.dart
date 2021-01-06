import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/6 上午11:02
// usage ：大师提现账号申请
// ------------------------------------------------------

class MasterDrawMoneyAdd extends StatefulWidget {
  MasterDrawMoneyAdd({Key key}) : super(key: key);

  @override
  _MasterDrawMoneyAddState createState() => _MasterDrawMoneyAddState();
}

class _MasterDrawMoneyAddState extends State<MasterDrawMoneyAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "测试"),
      body:_lv(),
      backgroundColor:primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[

      ],
    );
  }
}
