import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 14:57
// usage ：分页查询代理申请记录
// ------------------------------------------------------

class BrokerApplyHisPage extends StatefulWidget {
  BrokerApplyHisPage({Key key}) : super(key: key);

  @override
  _BrokerApplyHisPageState createState() => _BrokerApplyHisPageState();
}

class _BrokerApplyHisPageState extends State<BrokerApplyHisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "代理申请审批"),
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
