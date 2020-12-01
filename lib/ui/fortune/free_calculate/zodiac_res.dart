import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/small/cus_parse.dart';
import 'package:yiapp/model/free/zodiac_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 10:51
// usage ：显示生肖配对结果页面
// ------------------------------------------------------

class ZodiacResPage extends StatelessWidget {
  final ZodiacResult res;

  ZodiacResPage({this.res, Key key}) : super(key: key);

  List<Map> _parses = [];
  List<Map> _titles = []; // 标题 如 属兔的男的和属鼠的女的配吗？

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "配对结果",
        "contents": res.result,
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "爱情情缘",
        "contents": [res.qing_yuan],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "最佳表白日",
        "contents": [res.biao_bai.split(':')[1]],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "爱情誓言",
        "contents": [res.oath],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "定情花",
        "contents": res.flower,
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "定情宝石",
        "contents": [res.gem],
        "icon": FontAwesomeIcons.envira,
      },
    ];

    _titles = [
      {"text": "属", "color": t_gray},
      {"text": res.name.substring(1, 2), "color": t_yi},
      {"text": "的男的和属", "color": t_gray},
      {"text": res.name.substring(7, 8), "color": t_yi},
      {"text": "的女的配吗 ？", "color": t_gray},
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resData(); // 设置解析后的数据
    return Scaffold(
      appBar: CusAppBar(text: "生肖配对结果", backData: ""),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      children: <Widget>[
        // 标题
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(10)),
          child: RichText(
            text: TextSpan(children: <InlineSpan>[
              ..._titles.map((e) => TextSpan(
                    text: e['text'],
                    style: TextStyle(color: e['color'], fontSize: Adapt.px(32)),
                  ))
            ]),
          ),
        ),
        // 解析生肖配对数据
        ..._parses.map(
          (e) => ParseContent(
            title: e['title'],
            contents: e['contents'],
            icon: e['icon'],
          ),
        ),
        CusRaisedBtn(text: "重测一次", onPressed: () => Navigator.pop(context, ""))
      ],
    );
  }
}
