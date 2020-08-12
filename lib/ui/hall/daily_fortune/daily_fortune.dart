import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_article.dart';
import 'package:yiapp/complex/widgets/cus_behavior.dart';
import 'package:yiapp/complex/widgets/cus_circle_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/10 10:29
// usage ：每日运势
// ------------------------------------------------------

class DailyFortune extends StatefulWidget {
  DailyFortune({Key key}) : super(key: key);
  @override
  _DailyFortuneState createState() => _DailyFortuneState();
}

class _DailyFortuneState extends State<DailyFortune> {
  // 本地资源轮播
  final List<String> _loops = [
    "loop_1.jpg",
    "loop_2.png",
    "loop_3.jpg",
    "loop_4.jpg"
  ];

  // 算命功能区分类
  final List<Map> _assorts = [
    {"text": "八字精批", "path": "plate.png", "route": "temp"},
    {"text": "八字财运", "path": "plate.png", "route": "temp"},
    {"text": "八字合婚", "path": "plate.png", "route": "temp"},
    {"text": "八字事业", "path": "plate.png", "route": "temp"},
    {"text": "数字测试", "path": "plate.png", "route": "temp"},
    {"text": "桃花运势", "path": "plate.png", "route": "temp"},
    {"text": "姓名测试", "path": "plate.png", "route": "temp"},
    {"text": "学业测试", "path": "plate.png", "route": "temp"},
    {"text": "婚姻测试", "path": "plate.png", "route": "temp"},
    {"text": "2020年运", "path": "plate.png", "route": "temp"}
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        controller: ScrollController(keepScrollOffset: false),
        children: <Widget>[
          _loopArea(), // 轮播图
          _assortArea(), // 算命功能区分类
          _tip("精选评测"),
          ..._evaluationArea(),
        ],
      ),
    );
  }

  /// 轮播图
  Widget _loopArea() {
    return Container(
      height: Adapt.px(300),
      color: primary,
      child: Swiper(
        itemCount: _loops.length,
        itemBuilder: (context, index) {
          return Image.asset(
            "assets/images/loop/${_loops[index]}",
            fit: BoxFit.fill,
          );
        },
        onTap: (index) {
          print(">>>当前点的第${index + 1}张轮播图片");
        },
        autoplay: false, // 自动翻页
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            color: Colors.white,
            activeColor: Colors.blue,
            size: Adapt.px(18),
            activeSize: Adapt.px(18),
          ),
        ), // 分页指示
      ),
    );
  }

  /// 算命功能区分类
  Widget _assortArea() {
    return Container(
      color: primary,
      padding: EdgeInsets.only(
        left: Adapt.px(10),
        right: Adapt.px(10),
        top: Adapt.px(20),
        bottom: Adapt.px(10),
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5, // 横轴元素个数
        physics: BouncingScrollPhysics(),
        children: List.generate(
          _assorts.length,
          (i) {
            Map m = _assorts[i];
            return CusCircleItem(
              text: m['text'],
              path: "assets/images/${m['path']}",
              onTap: () => CusRoutes.pushNamed(context,
                  routeName: m['route'], arguments: m['text']),
            );
          },
        ),
      ),
    );
  }

  /// 精选评选
  List<Widget> _evaluationArea() {
    return _assorts.map((e) => CusArticle(title: e['text'])).toList();
  }

  Widget _tip(String text) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Text(
        text ?? "提示文字",
        style: TextStyle(fontSize: Adapt.px(32), color: t_primary),
      ),
    );
  }
}
