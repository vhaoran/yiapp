import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/pair/birth_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 10:42
// usage ：显示生日配对结果页面
// ------------------------------------------------------

class BirthResPage extends StatelessWidget {
  final BirthResult res;

  const BirthResPage({this.res, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "血型配对结果"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      children: <Widget>[],
    );
  }
}
