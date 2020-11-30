import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/demo/demo_plugin/flui_demo.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'flustars_demo.dart';

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
          title: "01 Flutter小部件UI库flui",
          onTap: () => CusRoutes.push(context, DemoFlui()),
        ),
        NormalBox(
          title: "02 Flustars 工具库",
          onTap: () => CusRoutes.push(context, DemoFlustars()),
        )
      ],
    );
  }
}
