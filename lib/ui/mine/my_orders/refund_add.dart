import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/30 下午3:15
// usage ：投诉大师订单
// ------------------------------------------------------

class RefundOrderAdd extends StatefulWidget {
  RefundOrderAdd({Key key}) : super(key: key);

  @override
  _RefundOrderAddState createState() => _RefundOrderAddState();
}

class _RefundOrderAddState extends State<RefundOrderAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "投诉大师订单"),
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
