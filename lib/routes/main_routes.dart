import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/temp_page.dart';
import 'package:yiapp/ui/fortune/daily_fortune/hehun_measure.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_main.dart';
import 'package:yiapp/ui/fortune/daily_fortune/sizhu_measure.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_main.dart';
import 'package:yiapp/ui/fortune/free_calculate/birth_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/blood_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/com_draw.dart';
import 'package:yiapp/ui/fortune/free_calculate/con_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/zhou_gong_page.dart';
import 'package:yiapp/ui/fortune/free_calculate/zodiac_pair.dart';
import 'package:yiapp/ui/home/home_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 16:06
// usage ：路由
// ------------------------------------------------------

final Map<String, WidgetBuilder> mainRoutes = {
  "home": (BuildContext context) => HomePage(),
  r_con_pair: (BuildContext context) => ConPairPage(), // 星座配对
  r_zodiac_pair: (BuildContext context) => ZodiacPairPage(), // 生肖配对
  r_blood_pair: (BuildContext context) => BloodPairPage(), // 血型配对
  r_birth_pair: (BuildContext context) => BirthPairPage(), // 生日配对
  r_com_draw: (BuildContext context) => ComDrawPage(), // 共用的免费抽灵签页面
  r_liu_yao: (BuildContext context) => LiuYaoPage(), // 六爻排盘
  r_sizhu: (BuildContext context) => SiZhuMeasure(), // 四柱测算
  r_he_hun: (BuildContext context) => HeHunMeasure(), // 合婚测算
  r_article: (BuildContext context) => ArticleMain(), // 精选文章
  r_zhou_gong: (BuildContext context) => ZhouGongPage(), // 周公解梦
  "temp": (BuildContext context) => TempPage(), // 临时页面[待删]
};
