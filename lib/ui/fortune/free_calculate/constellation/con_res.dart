import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_parse.dart';
import 'package:yiapp/model/pair/con_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 10:17
// usage ：显示星座配对结果页面
// ------------------------------------------------------

class ConResPage extends StatelessWidget {
  final ConResult res;

  ConResPage({this.res, Key key}) : super(key: key);

  List<Map> _parses;

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "解析",
        "contents": [res.parse],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "爱情情缘",
        "contents": [res.feel],
        "icon": FontAwesomeIcons.solidHeart,
      },
      {
        "title": "最佳表白日",
        "contents": [res.con_day.split(':')[1]],
        "icon": FontAwesomeIcons.fire
      },
      {
        "title": "爱情誓言",
        "contents": [res.oath],
        "icon": FontAwesomeIcons.solidComment,
      },
      {
        "title": "定情宝石",
        "contents": [res.gem],
        "icon": FontAwesomeIcons.solidGem,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resData(); // 设置解析后的数据
    return Scaffold(
      appBar: CusAppBar(text: "星座配对结果"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      children: <Widget>[
        // 什么星座配对
        _whichPair(res.name.split('＋')),
        // 配对指数
        ...res.stars.map(
          (e) => Text(e,
              style: TextStyle(color: t_primary, fontSize: Adapt.px(30))),
        ),
        SizedBox(height: Adapt.px(30)),
        Divider(thickness: 0.3, height: 0, color: t_gray),
        // 解析
        ..._parses.map((e) => ParseContent(
            title: e['title'], contents: e['contents'], icon: e['icon'])),
        CusRaisedBtn(text: "重测一次", onPressed: () => Navigator.pop(context))
      ],
    );
  }

  /// 什么星座配对
  Widget _whichPair(List<String> l) {
    var male = l[0].substring(0, 2); // 白羊男 → 白羊
    var female = l[1].substring(0, 2);
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(40), bottom: Adapt.px(10)),
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: "${male}座男和${female}座女",
                  style: TextStyle(color: t_yi, fontSize: Adapt.px(32)),
                ),
                TextSpan(
                  text: "的星座配对指数(五星为最佳)",
                  style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
