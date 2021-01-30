import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/temp/temp_page.dart';
import 'package:yiapp/ui/login/login_page.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_shake_page.dart';
import 'package:yiapp/ui/fortune/free_calculate/article/article_main.dart';
import 'package:yiapp/ui/luck/free_calculate/birth_pair.dart';
import 'package:yiapp/ui/luck/free_calculate/blood_pair.dart';
import 'package:yiapp/ui/luck/free_calculate/com_draw.dart';
import 'package:yiapp/ui/luck/free_calculate/con_pair.dart';
import 'package:yiapp/ui/luck/free_calculate/zhou_gong_page.dart';
import 'package:yiapp/ui/luck/free_calculate/zodiac_pair.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/ui/vip/hehun/hehun_measure_page.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_measure_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/22 16:06
// usage ：路由
// ------------------------------------------------------

final Map<String, WidgetBuilder> mainRoutes = {
  r_home: (BuildContext context) => HomePage(),
  r_login: (BuildContext context) => LoginPage(),
  r_con_pair: (BuildContext context) => ConPairPage(), // 星座配对
  r_zodiac_pair: (BuildContext context) => ZodiacPairPage(), // 生肖配对
  r_blood_pair: (BuildContext context) => BloodPairPage(), // 血型配对
  r_birth_pair: (BuildContext context) => BirthPairPage(), // 生日配对
  r_com_draw: (BuildContext context) => ComDrawPage(), // 共用的免费抽灵签页面
  r_liuyao: (BuildContext context) => LiuYaoShakePage(), // 六爻排盘
  r_sizhu: (BuildContext context) => SiZhuMeasurePage(), // 四柱测算测试
  r_hehun: (BuildContext context) => HeHunMeasurePage(), // 四柱测算测试
  r_article: (BuildContext context) => ArticleMain(), // 精选文章
  r_zhou_gong: (BuildContext context) => ZhouGongPage(), // 周公解梦
  "temp": (BuildContext context) => TempPage(), // 临时页面[待删]
};


// -------------------------- 统一命名路由 --------------------------
const String r_home = "/home"; // 首页
const String r_login = "/login"; // 登录页
