import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/provider/cus_provider.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'complex/function/permissions.dart';
import 'routes/main_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: CusProvider.providers,
      child: HongYunApp(),
    ),
  );
}

class HongYunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // 获取权限
//     Permissions.requestAll();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      routes: mainRoutes,
      // 这段代码用于实现全局点击空白处隐藏键盘
      builder: (context, child) => Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode curFocus = FocusScope.of(context);
            if (!curFocus.hasPrimaryFocus && curFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: child,
        ),
      ),
      home: HomePage(),
    );
  }
}
