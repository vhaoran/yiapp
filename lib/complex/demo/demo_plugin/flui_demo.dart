import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'dart:math';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午4:54
// usage ：Flutter小部件UI库flui
// ------------------------------------------------------

class DemoFlui extends StatefulWidget {
  DemoFlui({Key key}) : super(key: key);

  @override
  _DemoFluiState createState() => _DemoFluiState();
}

class _DemoFluiState extends State<DemoFlui> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "第三方插件 flui"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        FLGradientButton.linear(
          textColor: Colors.white,
          child: Text('按钮'),
          colors: [Colors.lightBlueAccent, Color(0xFF0F4C81)],
          onPressed: () => print('on click'),
        ),
        FLGradientButton.sweep(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          center: FractionalOffset.center,
          startAngle: 0.0,
//          endAngle:  math.pi* 2,
          colors: const <Color>[
            Color(0xFF4285F4), // blue
            Color(0xFF34A853), // green
            Color(0xFFFBBC05), // yellow
            Color(0xFFEA4335), // red
            Color(0xFF4285F4), // blue again to seamlessly transition to the start
          ],
          stops: const <double>[0.0, 0.25, 0.5, 0.75, 1.0],
          textColor: Colors.white,
          child: Text('Sweep Gradient Button'),
          onPressed: () => print('on click'),
        ),
      ],
    );
  }
}
