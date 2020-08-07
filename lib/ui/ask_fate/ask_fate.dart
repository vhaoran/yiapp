import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 19:33
// usage ：问命
// ------------------------------------------------------

class AskFatePage extends StatefulWidget {
  AskFatePage({Key key}) : super(key: key);
  @override
  _AskFatePageState createState() => _AskFatePageState();
}

class _AskFatePageState extends State<AskFatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(title: '问命页面'),
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
