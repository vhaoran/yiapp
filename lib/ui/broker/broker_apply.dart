import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:10
// usage ：申请成为代理
// ------------------------------------------------------

class ApplyBrokerPage extends StatefulWidget {
  ApplyBrokerPage({Key key}) : super(key: key);

  @override
  _ApplyBrokerPageState createState() => _ApplyBrokerPageState();
}

class _ApplyBrokerPageState extends State<ApplyBrokerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "代理申请"),
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
