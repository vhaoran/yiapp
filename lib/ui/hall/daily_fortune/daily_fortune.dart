import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/complex/const/const_color.dart';
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
    {"text": "八字精批", "path": "plate.png"},
    {"text": "八字财运", "path": "plate.png"},
    {"text": "八字合婚", "path": "plate.png"},
    {"text": "八字事业", "path": "plate.png"},
    {"text": "数字测试", "path": "plate.png"},
    {"text": "桃花运势", "path": "plate.png"},
    {"text": "姓名测试", "path": "plate.png"},
    {"text": "学业测试", "path": "plate.png"},
    {"text": "婚姻测试", "path": "plate.png"},
    {"text": "2020年运", "path": "plate.png"}
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _loopArea(), // 轮播图
        _assortArea(), // 算命功能区分类
      ],
    );
  }

  /// 轮播图
  Widget _loopArea() {
    return Container(
      height: 140,
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
            size: 8,
            activeSize: 8,
          ),
        ), // 分页指示
      ),
    );
  }

  /// 算命功能区分类
  Widget _assortArea() {
    return Container(
      color: primary,
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 5, // 横轴元素个数
        crossAxisSpacing: 5,
        children: List.generate(
          _assorts.length,
          (i) => CusCircleItem(
            text: _assorts[i]['text'],
            path: "assets/images/${_assorts[i]['path']}",
            onTap: _clickType,
          ),
        ),
      ),
    );
  }

  /// 点击算命按钮的种类
  void _clickType(String text) {
    print(">>>点了：$text");
    switch (text) {
      case "八字精批":
        break;
      case "八字财运":
        break;
      case "八字合婚":
        break;
      case "八字事业":
        break;
      case "数字测试":
        break;
      case "桃花运势":
        break;
      case "姓名测试":
        break;
      case "学业测试":
        break;
      case "婚姻测试":
        break;
      case "2020年运":
        break;
      default:
        break;
    }
  }
}
