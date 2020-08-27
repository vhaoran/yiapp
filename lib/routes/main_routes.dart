import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/temp_page.dart';
import 'package:yiapp/ui/fortune/free_calculate/blood/blood_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/constellation/con_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/zodiac/zodiac_pair.dart';
import 'package:yiapp/ui/home/home_page.dart';

final Map<String, WidgetBuilder> mainRoutes = {
  "home": (BuildContext context) => HomePage(),
  "temp": (BuildContext context) => TempPage(), // 临时页面[待删]
  con_pair: (BuildContext context) => ConPairPage(), // 星座配对
  zodiac_pair: (BuildContext context) => ZodiacPairPage(), // 生肖配对
  blood_pair: (BuildContext context) => BloodPairPage(), // 血型配对
};
