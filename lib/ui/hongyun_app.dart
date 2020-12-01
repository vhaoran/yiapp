import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // 获取权限
    // Permissions.requestAll();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      routes: mainRoutes,
      builder: (context, child) => _builder(context, child),
      home: HomePage(),
    );
  }

  /// 全局点击空白处隐藏键盘
  Widget _builder(context, child) {
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
