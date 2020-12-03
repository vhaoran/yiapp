import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/luck/luck_loop.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/temp/cus_time.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
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
  DateTime _now; // 当前时间
  Lunar _lunar;

  @override
  void initState() {
    _now = DateTime.now();
    _lunar = Lunar(_now);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          LuckLoops(),
//          _loop(), // 轮播图
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
          _title(text: "付费测算"),
//          _itemView(LuckList.pay),
          _title(text: "免费测算"),
//          _itemView(LuckList.free),
        ],
      ),
    );
  }

  /// 算命功能区分类
//  Widget _itemView(List<Map> l) {
//    return Container(
//      color: primary,
//      padding: EdgeInsets.all(5),
//      child: GridView.count(
//        physics: NeverScrollableScrollPhysics(),
//        shrinkWrap: true,
//        mainAxisSpacing: 5,
//        crossAxisCount: 5,
//        children: <Widget>[
//          ...l.map(
//            (e) => CusCircleItem(
//              text: e['text'],
//              icon: e['icon'],
//              bgColor: e['color'],
//              onTap: () => CusRoute.pushNamed(
//                context,
//                e['route'],
//                arguments: e['text'],
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  /// 显示时间区域
  Widget _timeArea() {
    return InkWell(
      onTap: () => CusRoute.push(context, AlmanacPage()),
      child: Container(
        height: 40,
        child: Row(
          children: <Widget>[
            Spacer(),
            Container(
              alignment: Alignment.center,
              child: Text(
                "${CusTime.ymd(_now.toString())} ${CusTime.dayEarthMd()}",
                style: TextStyle(color: t_primary, fontSize: Adapt.px(32)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Adapt.px(16), left: Adapt.px(36)),
              child: CusBtn(
                text: "详情",
                backgroundColor: t_primary,
                textColor: Colors.black,
                fontSize: 24,
                pdHor: 14,
                onPressed: () => CusRoute.push(context, AlmanacPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 封装的宜忌组件
  Widget _yiOrJiCts(List<String> l, {Color color = t_yi, bool isYi = true}) {
    l.insert(0, isYi ? "宜" : "忌");
    final int max = 8;
    return Row(
      children: List.generate(
        l.length >= max ? max : l.length,
        (index) {
          return Container(
            padding: EdgeInsets.all(Adapt.px(6)),
            width: Adapt.screenW() / max,
            child: Text(
              l[index],
              style: TextStyle(color: color, fontSize: Adapt.px(28)),
              overflow: TextOverflow.ellipsis,
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

  /// 付费、免费测算标题
  Widget _title({String text}) {
    return Container(
      padding: EdgeInsets.all(Adapt.px(20)),
      color: fif_primary,
      child: Text(
        text,
        style: TextStyle(fontSize: Adapt.px(32), color: t_primary),
      ),
    );
  }
}
