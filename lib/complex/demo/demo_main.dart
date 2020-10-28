import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/demo/date_timed_demo.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/service/api/api-pay.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mine/com_pay_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/13 13:27
// usage ：demo测试的入口
// ------------------------------------------------------

class CusDemoMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "demo测试"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      children: [
        SizedBox(height: Adapt.px(10)),
        NormalBox(
          title: "01 自定义日历",
          onTap: () => CusRoutes.push(context, CusTimePickerDemo()),
        ),
        NormalBox(
          title: "02 支付功能测试",
          onTap: () => _testPay(context),
        ),
      ],
    );
  }

  void _testPay(context) async {
    CusRoutes.push(
      context,
      ComPayPage(tip: "悬赏帖付款", b_type: b_bbs_prize, orderId: "", amt: 0.01),
    );
  }
}
