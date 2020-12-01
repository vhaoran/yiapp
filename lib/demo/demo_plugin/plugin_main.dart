import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_box.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午4:53
// usage ：关于第三方插件的测试
// ------------------------------------------------------

class DemoPlugin extends StatelessWidget {
  DemoPlugin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "关于第三方插件"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "01",
          onTap: () {},
        ),
      ],
    );
  }
}
