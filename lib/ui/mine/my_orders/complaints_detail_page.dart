import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/5 上午11:49
// usage ：查看投诉大师订单的详情
// ------------------------------------------------------

class ComplaintsDetailPage extends StatefulWidget {
  final bool isHis;

  ComplaintsDetailPage({this.isHis: false, Key key}) : super(key: key);

  @override
  _ComplaintsDetailPageState createState() => _ComplaintsDetailPageState();
}

class _ComplaintsDetailPageState extends State<ComplaintsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "详情"),
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
