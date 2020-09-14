import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:12
// usage ：大师个人信息页面
// ------------------------------------------------------

class MasterInfoPage extends StatefulWidget {
  MasterInfoPage({Key key}) : super(key: key);

  @override
  _MasterInfoPageState createState() => _MasterInfoPageState();
}

class _MasterInfoPageState extends State<MasterInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师信息"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[

      ],
    );
  }
}
