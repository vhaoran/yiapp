import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/model/pair/ConResult.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 10:17
// usage ：星座配对结果页面
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
        "content": res.parse,
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "爱情情缘",
        "content": res.feel,
        "icon": FontAwesomeIcons.solidHeart,
      },
      {
        "title": "最佳表白日",
        "content": res.con_day.split(':')[1],
        "icon": FontAwesomeIcons.fire
      },
      {
        "title": "爱情誓言",
        "content": res.oath,
        "icon": FontAwesomeIcons.solidComment,
      },
      {
        "title": "定情宝石",
        "content": res.gem,
        "icon": FontAwesomeIcons.solidGem,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resData(); // 设置解析后的数据
    return Scaffold(
      appBar: CusAppBar(text: "星座配对结果"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
        child: _lv(context),
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
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
        ..._parses.map((e) => _parseContent(
            title: e['title'], content: e['content'], icon: e['icon'])),
        CusRaisedBtn(text: "重测一次", onPressed: () => Navigator.pop(context))
      ],
    );
  }

  /// 封装的解析单个内容组件
  Widget _parseContent({String title, content, IconData icon}) {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(15), bottom: Adapt.px(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: t_yi, size: Adapt.px(30)),
              Text(
                "  $title",
                style: TextStyle(color: t_yi, fontSize: Adapt.px(32)),
              ),
            ],
          ),
          SizedBox(height: Adapt.px(10)),
          Text(
            content,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          ),
          SizedBox(height: Adapt.px(30)),
          Divider(thickness: 0.3, height: 0, color: t_gray),
        ],
      ),
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
