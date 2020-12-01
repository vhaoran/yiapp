import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'loading_demo.dart';
import 'time_picker_demo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午2:29
// usage ：关于演示效果的 demo
// ------------------------------------------------------

class DemoEffect extends StatelessWidget {
  DemoEffect({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "效果演示"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: <Widget>[
        NormalBox(
          title: "01 自定义日历",
          onTap: () => CusRoute.push(context, CusTimePickerDemo()),
        ),
        NormalBox(
          title: "02 自定义Loading加载框",
          onTap: () => CusRoute.push(context, LoadingDemo()),
        ),
      ],
    );
  }
}
