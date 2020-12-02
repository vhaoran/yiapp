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
        // 强制竖屏
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        // 获取权限
        // Permissions.requestAll();
        //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
        ScreenUtil.init(constraints);
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
      },
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
