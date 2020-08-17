import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:39
// usage ：命理圈
// ------------------------------------------------------

class FateCirclePage extends StatefulWidget {
  FateCirclePage({Key key}) : super(key: key);

  @override
  _FateCirclePageState createState() => _FateCirclePageState();
}

class _FateCirclePageState extends State<FateCirclePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    print(">>>进了命理圈");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "命理圈",showLeading: false),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    return ListView(
      children: <Widget>[],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
