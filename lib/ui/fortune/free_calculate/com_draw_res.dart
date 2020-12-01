import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/small/cus_parse.dart';
import 'package:yiapp/model/free/chegong_result.dart';
import 'package:yiapp/model/free/daxian_result.dart';
import 'package:yiapp/model/free/guandi_result.dart';
import 'package:yiapp/model/free/guanyin_result.dart';
import 'package:yiapp/model/free/lvzu_result.dart';
import 'package:yiapp/model/free/mazu_result.dart';
import 'package:yiapp/model/free/yuelao_result.dart';
import 'package:yiapp/ui/fortune/free_calculate/draw_parse.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 18:05
// usage ：通用的灵签结果页面
// ------------------------------------------------------

class ComDrawResPage extends StatelessWidget {
  final String title;
  final dynamic result; // 动态传递的灵签类型

  ComDrawResPage({
    this.title: "灵签结果",
    this.result,
    Key key,
  }) : super(key: key);

  List<Map> _parses = []; // 显示数据
  String _name = ""; // 标题显示，如哪个灵签的第几签

  @override
  Widget build(BuildContext context) {
    _drawType();
    return Scaffold(
      appBar: CusAppBar(text: title),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
        children: <Widget>[
          // 标题
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: Adapt.px(30), bottom: Adapt.px(10)),
            child: Text(
              _name,
              style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
            ),
          ),
          // 内容
          ..._parses.map(
            (e) => ParseContent(
              title: e['title'],
              contents: e['contents'],
            ),
          ),
          // 重测按钮
          CusRaisedBtn(text: "再抽一签", onPressed: () => Navigator.pop(context))
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 选择灵签类型
  void _drawType() {
    _name = result.name.substring(5);
    // 大仙
    if (result is DaXianResult) {
      _parses = DrawParse.daXian(result);
    }
    // 关公
    else if (result is GuanDiResult) {
      _parses = DrawParse.guanDi(result);
    }
    // 观音
    else if (result is GuanYinResult) {
      _parses = DrawParse.guanYin(result);
    }
    // 妈祖
    else if (result is MaZuResult) {
      _parses = DrawParse.maZu(result);
    }
    // 月老
    else if (result is YueLaoResult) {
      _parses = DrawParse.yueLao(result);
    }
    // 车公
    else if (result is CheGongResult) {
      _parses = DrawParse.cheGong(result);
    }
    // 吕祖
    else if (result is LvZuResult) {
      _parses = DrawParse.lvZu(result);
    }
  }
}
