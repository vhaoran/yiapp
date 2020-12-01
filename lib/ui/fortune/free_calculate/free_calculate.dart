import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/small/cus_square_item.dart';

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
  // 热门配对
  final List<Map> _pairs = [
    {
      "text": "星座配对",
      "icon": 0xe69e,
      "color": 0xFFF0D15F,
      "route": r_con_pair,
    },
    {
      "text": "生肖配对",
      "icon": 0xe6b1,
      "color": 0xFF78BA3B,
      "route": r_zodiac_pair
    },
    {
      "text": "血型配对",
      "icon": 0xe656,
      "color": 0xFFDE524B,
      "route": r_blood_pair
    },
    {
      "text": "生日配对",
      "icon": 0xe728,
      "color": 0xFF74C1FA,
      "route": r_birth_pair
    },
  ];

  /// 热门灵签
  final List<Map> _signs = [
    {"text": "观音灵签", "icon": 0xe601, "color": 0xFFB991DB, "route": r_com_draw},
    {"text": "月老灵签", "icon": 0xe606, "color": 0xFFE1567C, "route": r_com_draw},
    {"text": "关公灵签", "icon": 0xe627, "color": 0xFFEB7949, "route": r_com_draw},
    {"text": "大仙灵签", "icon": 0xe600, "color": 0xFF67C76C, "route": r_com_draw},
    {"text": "妈祖灵签", "icon": 0xe668, "color": 0xFFEDBF4F, "route": r_com_draw},
    {"text": "吕祖灵签", "icon": 0xebcd, "color": 0xFF81D755, "route": r_com_draw},
    {"text": "车公灵签", "icon": 0xe604, "color": 0xFF75C1E9, "route": r_com_draw},
  ];

  // 个性推荐
  final List<Map> _specific = [
    {"text": "精选文章", "icon": 0xe6b5, "color": 0xFFB991DB, "route": r_article},
    {"text": "周公解梦", "icon": 0xe6ce, "color": 0xFFDE524B, "route": r_zhou_gong},
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          _title("热门配对"),
          _comCtr(_pairs),
          _title("热门灵签"),
          _comCtr(_signs),
          _title("个性推荐"),
          _comCtr(_specific),
        ],
      ),
    );
  }

  Widget _comCtr(List<Map> l) {
    return Container(
      color: primary,
      padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 5,
        crossAxisCount: 5,
        children: <Widget>[
          ...l.map(
            (e) => CusSquareItem(
              text: e['text'],
              icon: e['icon'],
              bgColor: e['color'],
              onTap: () => CusRoute.pushNamed(
                context,
                e['route'],
                arguments: e['text'],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 标题提示
  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Text(
        text,
        style: TextStyle(fontSize: Adapt.px(32), color: t_primary),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
