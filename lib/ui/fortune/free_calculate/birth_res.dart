import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_parse.dart';
import 'package:yiapp/model/free/birth_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 10:42
// usage ：显示生日配对结果页面
// ------------------------------------------------------

class BirthResPage extends StatelessWidget {
  final BirthResult res;

  BirthResPage({this.res, Key key}) : super(key: key);

  List<Map> _parses = [];

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "配对结果",
        "contents": res.result,
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "爱情誓言",
        "contents": [res.oath],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "吉日",
        "contents": res.jiRi,
        "icon": FontAwesomeIcons.envira,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resData(); // 设置解析后的数据
    return Scaffold(
      appBar: CusAppBar(text: "血型配对结果"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      children: <Widget>[
        // 生日配吗
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(30), bottom: Adapt.px(10)),
          child: Text(
            res.name,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
          ),
        ),
        // 主体内容
        ..._parses.map(
          (e) => ParseContent(
            title: e['title'],
            contents: e['contents'],
            icon: e['icon'],
          ),
        ),
        // 重测按钮
        CusRaisedBtn(text: "重测一次", onPressed: () => Navigator.pop(context))
      ],
    );
  }
}
