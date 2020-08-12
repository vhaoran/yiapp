import 'package:flutter/material.dart';
import 'package:yiapp/complex/temp_page.dart';
import 'package:yiapp/ui/home/home_page.dart';

final Map<String, WidgetBuilder> mainRoutes = {
  "home": (BuildContext context) => HomePage(),
  "temp": (BuildContext context) => TempPage(),
};
