import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/provider/cus_provider.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'complex/function/permissions.dart';
import 'routes/main_routes.dart';
import 'service/api/api_base.dart';

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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      routes: mainRoutes,
      home: _choice(),
    );
  }

  Widget _choice() {
    // 获取权限
    Permissions.requestAll();
    return ApiBase.login ? HomePage() : LoginPage();
  }
}
