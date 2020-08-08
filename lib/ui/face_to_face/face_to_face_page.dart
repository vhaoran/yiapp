import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:40
// usage ：面对面
// ------------------------------------------------------

class FaceToFacePage extends StatefulWidget {
  FaceToFacePage({Key key}) : super(key: key);
  @override
  _FaceToFacePageState createState() => _FaceToFacePageState();
}

class _FaceToFacePageState extends State<FaceToFacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(title: '面对面'),
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
