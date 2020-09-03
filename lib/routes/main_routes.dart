import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/demo/datetimed_demo.dart';
import 'package:yiapp/complex/temp_page.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_main.dart';
import 'package:yiapp/ui/fortune/free_calculate/birth_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/blood_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/com_draw.dart';
import 'package:yiapp/ui/fortune/free_calculate/con_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/zodiac_pair.dart';
import 'package:yiapp/ui/home/home_page.dart';

final Map<String, WidgetBuilder> mainRoutes = {
  "home": (BuildContext context) => HomePage(),
  con_pair: (BuildContext context) => ConPairPage(), // 星座配对
  zodiac_pair: (BuildContext context) => ZodiacPairPage(), // 生肖配对
  blood_pair: (BuildContext context) => BloodPairPage(), // 血型配对
  birth_pair: (BuildContext context) => BirthPairPage(), // 生日配对
  com_draw: (BuildContext context) => ComDrawPage(), // 共用的免费抽灵签页面
  liu_yao: (BuildContext context) => LiuYaoPage(), // 六爻排盘
  "temp": (BuildContext context) => TempPage(), // 临时页面[待删]
  "date_demo": (BuildContext context) => DateTimeDemo(), // 阴阳历测试
};
