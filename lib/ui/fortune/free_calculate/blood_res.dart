import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_parse.dart';
import 'package:yiapp/free_model/pairs/blood_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 17:19
// usage ：显示血型配对结果页面
// ------------------------------------------------------

class BloodResPage extends StatelessWidget {
  final BloodResult res;

  BloodResPage({this.res, Key key}) : super(key: key);

  List<Map> _parses= [];

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "彼此吸引点",
        "contents": [res.advantage],
        "icon": FontAwesomeIcons.envira,
      },
      {
        "title": "最佳表白日",
        "contents": [res.confession_day.split(':')[1]],
        "icon": FontAwesomeIcons.fire,
      },
      {
        "title": "可能出现的问题",
        "contents": [res.disadvantage],
        "icon": FontAwesomeIcons.questionCircle,
      },
      {
        "title": "爱情誓言",
        "contents": [res.disadvantage],
        "icon": FontAwesomeIcons.solidComment,
      },
      {
        "title": "增进感情的方式",
        "contents": [res.plus],
        "icon": FontAwesomeIcons.solidComment,
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
        // 什么血型
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
