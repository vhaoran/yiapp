import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/cus_article.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/cus_circle_item.dart';
import 'package:yiapp/ui/fortune/almanac/almanac_page.dart';

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
  DateTime _cusTime; // 当前时间
  Lunar _lunar;
  final int _maxCount = 8; // 最多显示宜、忌项的个数
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

  // 好物列表
  final List<Map> _goods = [
    {"text": "恋爱桃花", "route": "temp"},
    {"text": "健康平安", "route": "temp"},
    {"text": "财富事业", "route": "temp"},
    {"text": "学业职场", "route": "temp"},
    {"text": "破灾符", "route": "temp"},
    {"text": "聚财符", "route": "temp"},
    {"text": "平安符", "route": "temp"},
    {"text": "感情符", "route": "temp"},
  ];

  @override
  void initState() {
    _cusTime = DateTime.now();
    _lunar = Lunar(_cusTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          _loopArea(), // 轮播图
          _assortArea(), // 算命功能区分类
          _timeArea(), // 显示黄历时间
          Container(
            color: primary,
            child: Column(
              children: <Widget>[
                _yiOrJiCts(_lunar.dayYi), // 宜
                _yiOrJiCts(_lunar.dayJi, color: t_ji, isYi: false), // 忌
              ],
            ),
          ),
          _tip("好物列表"),
          _goodsArea(), // 好物列表
          _tip("精选评测"),
          ..._evaluationArea(), // 精选评测
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

  /// 显示时间区域
  Widget _timeArea() {
    return InkWell(
      onTap: () => CusRoutes.push(context, AlmanacPage()),
      child: Container(
        height: Adapt.px(72),
        child: Row(
          children: <Widget>[
            Spacer(),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${CusTime.ymd(_cusTime.toString())} ${CusTime.dayEarthMd()}",
                style: TextStyle(color: t_primary, fontSize: Adapt.px(32)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Adapt.px(16), left: Adapt.px(36)),
              child: CusRaisedBtn(
                text: "详情",
                backgroundColor: t_primary,
                textColor: Colors.black,
                fontSize: 24,
                pdHor: 14,
                onPressed: () => CusRoutes.push(context, AlmanacPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 好物列表区域
  Widget _goodsArea() {
    return Container(
      color: primary,
      child: Wrap(
        children: List.generate(
          _goods.length,
          (index) {
            var e = _goods[index];
            return InkWell(
              onTap: () => CusRoutes.pushNamed(context,
                  routeName: e['route'], arguments: e['text']),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(6),
                width: Adapt.screenW() / 4,
                child: Text(
                  "${e['text']}",
                  style: TextStyle(color: t_primary, fontSize: Adapt.px(28)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 精选评测
  List<Widget> _evaluationArea() {
    // 再大的愿景都是从小处着手，越大的图越要从小处搞，越小的东西越要从大处着眼
    return _assorts.map((e) => CusArticle(title: e['text'])).toList();
  }

  /// 封装的宜忌组件
  Widget _yiOrJiCts(List<String> l, {Color color = t_yi, bool isYi = true}) {
    l.insert(0, isYi ? "宜" : "忌");
    return Row(
      children: List.generate(
        l.length >= _maxCount ? _maxCount : l.length,
        (index) {
          bool fourWords = l[index].length >= 4 ? true : false;
          int width = fourWords ? _maxCount - 3 : _maxCount;
          return Container(
            padding: EdgeInsets.all(Adapt.px(6)),
            width: Adapt.screenW() / width,
            child: Text(
              l[index],
              style: TextStyle(color: color, fontSize: Adapt.px(28)),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700], width: 0),
            ),
          );
        },
      ),
    );
  }

  /// 如"精选评测"等提示内容
  Widget _tip(String text, {double fontSize = 32, double padding = 20}) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(padding)),
      child: Text(
        text ?? "提示文字",
        style: TextStyle(fontSize: Adapt.px(fontSize), color: t_primary),
      ),
    );
  }
}
