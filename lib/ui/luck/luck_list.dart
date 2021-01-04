import 'package:yiapp/const/con_string.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午5:13
// usage ：运势页面列表数据
// ------------------------------------------------------

class LuckList {
  ///  本地资源轮播
  static final List<String> loops = [
    "loop_1.jpg",
    "loop_2.png",
    "loop_3.jpg",
    "loop_4.jpg",
  ];

  /// 付费测算
  static final List<Map<String, dynamic>> pay = [
    {
      "text": "四柱测算",
      "color": 0xFFEEA988,
      "route": r_sizhu,
    },
    {
      "text": "六爻排盘",
      "color": 0xFFA18CF7,
      "route": r_liu_yao,
    },
    {
      "text": "合婚测算",
      "color": 0xFFE86E66,
      "route": r_he_hun,
    },
  ];

  /// 免费测算
  static const List<Map<String, dynamic>> free = [
    // 热门配对
    {
      "text": "星座配对",
      "color": 0xFFF0D15F,
      "route": r_con_pair,
    },
    {
      "text": "生肖配对",
      "color": 0xFF78BA3B,
      "route": r_zodiac_pair
    },
    {
      "text": "血型配对",
      "color": 0xFFDE524B,
      "route": r_blood_pair
    },
    {
      "text": "生日配对",
      "color": 0xFF74C1FA,
      "route": r_birth_pair
    },
    // 热门灵签
    {
      "text": "观音灵签",
      "color": 0xFFB991DB,
      "route": r_com_draw,
    },
    {
      "text": "月老灵签",
      "color": 0xFFE1567C,
      "route": r_com_draw,
    },
    {
      "text": "关公灵签",
      "color": 0xFFEB7949,
      "route": r_com_draw,
    },
    {
      "text": "大仙灵签",
      "color": 0xFF67C76C,
      "route": r_com_draw,
    },
    {
      "text": "妈祖灵签",
      "color": 0xFFEDBF4F,
      "route": r_com_draw,
    },
    {
      "text": "吕祖灵签",
      "color": 0xFF81D755,
      "route": r_com_draw,
    },
    {
      "text": "车公灵签",
      "color": 0xFF75C1E9,
      "route": r_com_draw,
    },
    // 个性推荐
    {
      "text": "精选文章",
      "color": 0xFFB991DB,
      "route": r_article,
    },
    {
      "text": "周公解梦",
      "color": 0xFFDE524B,
      "route": r_zhou_gong,
    },
  ];
}

/// 运势中免费、付费的配置项
class LuckIcon {
  String text; // 底部名称
  int color; // 背景色
  String route; // 路由名称

  LuckIcon({this.text,this.color, this.route});

  LuckIcon.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    color = json['color'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.text;
    data['color'] = this.color;
    data['route'] = this.route;
    return data;
  }
}
