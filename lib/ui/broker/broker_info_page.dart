import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:11
// usage ：代理个人信息页面
// ------------------------------------------------------

class BrokerInfoPage extends StatefulWidget {
  BrokerInfoPage({Key key}) : super(key: key);

  @override
  _BrokerInfoPageState createState() => _BrokerInfoPageState();
}

class _BrokerInfoPageState extends State<BrokerInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "代理信息"),
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
