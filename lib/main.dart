import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'routes/main_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: HomePage(),
    );
  }
}
