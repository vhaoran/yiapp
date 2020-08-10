import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/10 10:31
// usage ：免费测算
// ------------------------------------------------------

class FreeCalculate extends StatefulWidget {
  FreeCalculate({Key key}) : super(key: key);
  @override
  _FreeCalculateState createState() => _FreeCalculateState();
}

class _FreeCalculateState extends State<FreeCalculate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('免费测算'),
      ],
    );
  }
}
