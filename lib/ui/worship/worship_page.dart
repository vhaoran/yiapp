import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:40
// usage ：底部导航栏 - 供奉页面
// ------------------------------------------------------

class WorshipPage extends StatefulWidget {
  WorshipPage({Key key}) : super(key: key);
  @override
  _WorshipPageState createState() => _WorshipPageState();
}

class _WorshipPageState extends State<WorshipPage>
    with AutomaticKeepAliveClientMixin {
  void initState() {
    Log.info("进了供奉页面");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "供奉", showLeading: false),
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
