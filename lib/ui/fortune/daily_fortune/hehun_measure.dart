import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 16:05
// usage ：合婚测算
// ------------------------------------------------------

class HeHunMeasure extends StatefulWidget {
  HeHunMeasure({Key key}) : super(key: key);

  @override
  _HeHunMeasureState createState() => _HeHunMeasureState();
}

class _HeHunMeasureState extends State<HeHunMeasure> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "合婚测算"),
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
