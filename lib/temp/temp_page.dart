import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/12 17:35
// usage ：临时页面，因为目前还不知道定哪些业务
// ------------------------------------------------------

class TempPage extends StatelessWidget {
  const TempPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = ModalRoute.of(context).settings.arguments ?? "默认页面";
    return Scaffold(
      appBar: CusAppBar(text: title),
      body: Center(
        child: Text(
          "《$title》 页面",
          style: TextStyle(fontSize: 18, color: Colors.yellow),
        ),
      ),
      backgroundColor: primary,
    );
  }
}
