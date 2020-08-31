import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:25
// usage ：自定义路由
// ------------------------------------------------------

class CusRoutes {
  // push 跳转到下一个页面
  static Future<dynamic> push(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // pushReplacement 跳转到下一个页面并销毁当前页面
  static Future<dynamic> pushReplacement(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // pushNamed 根据路由名称跳转页面
  static Future<dynamic> pushNamed(BuildContext context, String routeName,
      {dynamic arguments}) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}
