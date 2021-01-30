import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:25
// usage ：自定义路由
// ------------------------------------------------------

class CusRoute {
  /// push 跳到指定的组件路由页面
  static Future<dynamic> push(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// pushNamed 跳到指定名称的页面
  static Future<dynamic> pushNamed(BuildContext context, String routeName,
      {dynamic arguments}) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  // ----------------------------------------------------------------------

  /// pushReplacement 跳到指定的组件路由页面，并替换当前页面
  static Future<dynamic> pushReplacement(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// pushReplacementNamed 跳到指定名称的页面，并替换当前页面，只显示推进动画
  /// 用途：登录页面用户成功登录，登录页面应由首页代替，保证用户无法再回到登录页面
  static Future<dynamic> pushReplacementNamed(
      BuildContext context, String routeName,
      {dynamic arguments}) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// popAndPushNamed 跳回上一个页面并同时跳到指定名称的页面
  /// 先显示当前页面的弹出动画，然后再显示跳回页面的推进动画
  static Future<dynamic> popAndPushNamed(BuildContext context, String routeName,
      {dynamic arguments}) {
    return Navigator.popAndPushNamed(context, routeName, arguments: arguments);
  }

  // ----------------------------------------------------------------------

  /// pushNamedAndRemoveUntil 跳到指定名称的页面，并移除之前所有的页面
  /// 用途：用户退出登录然后跳到登录页面，确保用户不会再回到之前的页面
  static Future<dynamic> pushNamedAndRemoveAllUntil(
      BuildContext context, String routeName,
      {dynamic arguments}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (Route route) => false, // 确保删除先前所有实例
      arguments: arguments,
    );
  }

  /// pushNamedAndRemoveUntil 跳到指定名称的页面并删除所有路由，直到 stopName 名称页面
  /// 用途：一个需要付款交易的购物应用，当用户完成支付交易，应该从堆栈中删除所有与交易
  /// 或购物车相关的页面，并且用户被带到订单详情页，点击返回按钮把用户带回首页或者商品列表
  static Future<dynamic> pushNamedAndRemoveWhereUntil(
      BuildContext context, String pushName, String stopName,
      {dynamic arguments}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      pushName,
      ModalRoute.withName(stopName), // 确保删除先前所有实例
      arguments: arguments,
    );
  }

  /// popUntil 退回到指定名称的页面
  /// 如用户已经填写信息到第三个页面，此时取消填写，应弹出所有之前与表单相关的页面，并将用户带到
  /// 首页或者准备填写表单页，此情况属于数据无效，不需要推送任何新东西，只是回到以前的路由栈中
  static void popUntil(BuildContext context, String routeName,
      {dynamic arguments}) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
