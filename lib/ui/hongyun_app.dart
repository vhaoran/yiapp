import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiapp/global/main_routes.dart';
import 'home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午4:54
// usage ：鸿运 App
// ------------------------------------------------------

class HongYunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _systemPrepare(context, constraints);
        return MaterialApp(
          home: HomePage(),
          routes: mainRoutes,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          debugShowCheckedModeBanner: false,
          builder: (context, child) => _materialBuilder(context, child),
        );
      },
    );
  }

  /// 系统准备
  void _systemPrepare(BuildContext context, BoxConstraints constraints) {
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // 获取权限
    // Permissions.requestAll();
    // 设计稿以 iPhone6 尺寸设计(750*1334)
    ScreenUtil.init(constraints, designSize: Size(750, 1334));
  }

  /// 全局点击空白处隐藏键盘
  Widget _materialBuilder(BuildContext context, Widget child) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode curFocus = FocusScope.of(context);
          if (!curFocus.hasPrimaryFocus && curFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: child,
      ),
    );
  }
}
