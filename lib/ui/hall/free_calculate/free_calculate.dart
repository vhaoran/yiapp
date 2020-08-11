import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_article.dart';
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
    {"text": "人体节律", "path": "temp_girl.jpg"},
    {"text": "姓名配对", "path": "temp_girl.jpg"},
    {"text": "星座配对", "path": "temp_girl.jpg"},
    {"text": "生肖配对", "path": "temp_girl.jpg"},
    {"text": "血型配对", "path": "temp_girl.jpg"},
    {"text": "手机号吗", "path": "temp_girl.jpg"},
    {"text": "眼跳吉凶", "path": "temp_girl.jpg"},
    {"text": "指纹吉凶", "path": "temp_girl.jpg"},
    {"text": "生日配对", "path": "temp_girl.jpg"},
    {"text": "QQ号码", "path": "temp_girl.jpg"},
  ];

  // 个性推荐
  final List<Map> _personality = [
    {"text": "周公解梦", "path": "temp_boy.jpg"},
    {"text": "生肖运势", "path": "temp_boy.jpg"},
    {"text": "生肖算命", "path": "temp_boy.jpg"},
    {"text": "称骨算命", "path": "temp_boy.jpg"},
    {"text": "缘分测试", "path": "temp_boy.jpg"},
    {"text": "观音灵签", "path": "temp_boy.jpg"},
    {"text": "妈祖灵签", "path": "temp_boy.jpg"},
    {"text": "狐仙灵签", "path": "temp_boy.jpg"},
    {"text": "好友合盘", "path": "temp_boy.jpg"},
    {"text": "生命灵数", "path": "temp_boy.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _tip("热门推荐"),
        _popularArea(),
        _tip("个性推荐"),
        _personalityArea(),
        _tip("趣味测试"),
        CusArticle(),
      ],
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
        crossAxisCount: 5,
        crossAxisSpacing: 5,
        children: List.generate(
          _populars.length,
          (i) => CusSquareItem(
            text: _populars[i]["text"],
            path: "assets/images/${_populars[i]['path']}",
            onTap: _doPopular,
          ),
        ),
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
        crossAxisCount: 5,
        crossAxisSpacing: 5,
        children: List.generate(
          _personality.length,
          (i) => CusSquareItem(
            text: _personality[i]["text"],
            path: "assets/images/${_personality[i]['path']}",
            onTap: _doPersonality,
          ),
        ),
      ),
    );
  }

  /// 点击热门推荐的种类
  Widget _doPopular(String text) {
    print(">>>点了【热门推荐】中的:$text");
    switch (text) {
      case "人体节律":
        break;
      case "姓名配对":
        break;
      case "星座配对":
        break;
      case "生肖配对":
        break;
      case "血型配对":
        break;
      case "手机号吗":
        break;
      case "眼跳吉凶":
        break;
      case "指纹吉凶":
        break;
      case "生日配对":
        break;
      case "QQ号码":
        break;
      default:
        break;
    }
  }

  /// 点击个性推荐的种类
  Widget _doPersonality(String text) {
    print(">>>点了【个性推荐】中的:$text");
    switch (text) {
      case "周公解梦":
        break;
      case "生肖运势":
        break;
      case "生肖算命":
        break;
      case "称骨算命":
        break;
      case "缘分测试":
        break;
      case "观音灵签":
        break;
      case "妈祖灵签":
        break;
      case "狐仙灵签":
        break;
      case "好友合盘":
        break;
      case "生命灵数":
        break;
      default:
        break;
    }
  }

  Widget _tip(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Text(
        text ?? "提示文字",
        style: TextStyle(fontSize: 14, color: t_primary),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
