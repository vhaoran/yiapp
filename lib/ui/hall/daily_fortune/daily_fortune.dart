import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
  // 功能区分类
  final List<String> _assorts = [
    "八字精批",
    "八字财运",
    "八字合婚",
    "八字事业",
    "数字测试",
    "桃花运势",
    "姓名测试",
    "学业测试",
    "婚姻测试",
    "2020年运",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _loopArea(), // 轮播图
        _assortArea(), // 功能区分类
      ],
    );
  }

  /// 轮播图
  Widget _loopArea() {
    return Container(
      height: 140,
      constraints: BoxConstraints(minHeight: 140),
      padding: EdgeInsets.only(top: 5),
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
            size: 8,
            activeSize: 8,
          ),
        ), // 分页指示
      ),
    );
  }

  /// 功能区分类
  Widget _assortArea() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 160,
      constraints: BoxConstraints(minHeight: 160),
      child: GridView.count(
        crossAxisCount: 5, // 横轴元素个数
        mainAxisSpacing: 5, // 纵轴间距
        children: <Widget>[
          ..._assorts.map(
            (text) {
              int i = _assorts.indexWhere((e) => e == text);
              print(">>>${_imagePath(i)}");
              return CusCircleItem(
                text: text,
                path: "assets/images/${_imagePath(i)}",
                onTap: () {
                  print(">>>点了$text");
                },
              );
            },
          ).toList(),
        ],
      ),
    );
  }

  /// 图片路径
  String _imagePath(int i) {
    String name;
    switch (i) {
      case 0:
        name = "plate.png";
        break;
      case 1:
        name = "plate_bg.png";
        break;
      default:
        name = "plate.png";
        break;
    }
    return name;
  }
}
