import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/demo/demo_clear_data/clear_data_main.dart';
import 'package:yiapp/complex/demo/demo_effect/effect_main.dart';
import 'package:yiapp/complex/demo/demo_plugin/plugin_main.dart';
import 'package:yiapp/complex/demo/demo_simulate/simulate_main.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'demo_get_data/get_data_main.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/13 13:27
// usage ：测试的入口
// ------------------------------------------------------

class CusDemoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "测试"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: [
        SizedBox(height: Adapt.px(10)),
        NormalBox(
          title: "01 效果演示预览",
          onTap: () => CusRoutes.push(context, DemoEffect()),
        ),
        NormalBox(
          title: "02 虚拟场景预览",
          onTap: () => CusRoutes.push(context, DemoSimulate()),
        ),
        NormalBox(
          title: "03 清除数据相关",
          onTap: () => CusRoutes.push(context, DemoClearData()),
        ),
        NormalBox(
          title: "04 获取数据相关",
          onTap: () => CusRoutes.push(context, DemoGetData()),
        ),
        NormalBox(
          title: "05 第三方插件",
          onTap: () => CusRoutes.push(context, DemoPlugin()),
        ),
      ],
    );
  }
}
