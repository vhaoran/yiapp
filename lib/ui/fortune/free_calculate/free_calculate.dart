import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_article.dart';
import 'package:yiapp/complex/widgets/cus_behavior.dart';
import 'package:yiapp/complex/widgets/cus_square_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/10 10:31
// usage ：免费测算
// ------------------------------------------------------

class FreeCalculate extends StatefulWidget {
  FreeCalculate({Key key}) : super(key: key);

  @override
  _FreeCalculateState createState() => _FreeCalculateState();
}

class _FreeCalculateState extends State<FreeCalculate>
    with AutomaticKeepAliveClientMixin {
  // 热门推荐
  final List<Map> _populars = [
    {"text": "人体节律", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "姓名配对", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "星座配对", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "生肖配对", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "血型配对", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "手机号吗", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "眼跳吉凶", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "指纹吉凶", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "生日配对", "path": "temp_girl.jpg", "route": "temp"},
    {"text": "QQ号码", "path": "temp_girl.jpg", "route": "temp"},
  ];

  // 个性推荐
  final List<Map> _personality = [
    {"text": "周公解梦", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "生肖运势", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "生肖算命", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "称骨算命", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "缘分测试", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "观音灵签", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "妈祖灵签", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "狐仙灵签", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "好友合盘", "path": "temp_boy.jpg", "route": "temp"},
    {"text": "生命灵数", "path": "temp_boy.jpg", "route": "temp"},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          _tip("热门推荐"),
          _popularArea(),
          _tip("个性推荐"),
          _personalityArea(),
          _tip("趣味测试"),
          ..._savorArea(), // 模拟数据
        ],
      ),
    );
  }

  /// 热门推荐区域
  Widget _popularArea() {
    return Container(
      color: primary,
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 5,
        crossAxisCount: 5,
        children: List.generate(_populars.length, (i) {
          Map m = _populars[i];
          return CusSquareItem(
            text: m['text'],
            path: "assets/images/${m['path']}",
            onTap: () => CusRoutes.pushNamed(context,
                routeName: m['route'], arguments: m['text']),
          );
        }),
      ),
    );
  }

  /// 个性推荐区域
  Widget _personalityArea() {
    return Container(
      color: primary,
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 5,
        crossAxisCount: 5,
        children: List.generate(
          _personality.length,
          (i) {
            Map m = _personality[i];
            return CusSquareItem(
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

  /// 趣味测试区域
  List<Widget> _savorArea() {
    return _populars.map((e) => CusArticle(title: e['text'])).toList();
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

  @override
  bool get wantKeepAlive => true;
}
