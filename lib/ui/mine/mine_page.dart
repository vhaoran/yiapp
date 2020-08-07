import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:41
// usage ：个人主页
// ------------------------------------------------------

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(title: '测试'),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    return ListView(
      children: <Widget>[],
    );
  }
}
