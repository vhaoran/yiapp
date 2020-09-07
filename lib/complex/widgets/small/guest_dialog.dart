import 'package:flutter/material.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/login/login_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 17:07
// usage ：当为游客登录，点击部分功能弹出提示去登录的框
// ------------------------------------------------------

class CusGuest {
  static void log(BuildContext context) {
    CusDialog.normal(
      context,
      title: "暂未登录，现在去登录吗？",
      onApproval: () {
        print(">>>123");
        CusRoutes.push(context, LoginPage());
        print(">>>456");
      },
    );
  }
}
