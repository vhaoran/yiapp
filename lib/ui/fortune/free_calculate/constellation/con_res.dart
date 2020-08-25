import 'package:flutter/material.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 10:17
// usage ：星座配对结果页面
// ------------------------------------------------------

class ConResPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "星座配对结果"),
      body: Container(
        alignment: Alignment.center,
        color: Colors.grey,
      ),
    );
  }
}
