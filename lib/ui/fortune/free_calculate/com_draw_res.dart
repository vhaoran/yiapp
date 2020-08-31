import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/small/cus_parse.dart';
import 'package:yiapp/model/draw/daxian_result.dart';
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
              icon: e['icon'],
            ),
          ),
          // 重测按钮
          CusRaisedBtn(text: "重测一次", onPressed: () => Navigator.pop(context))
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 选择灵签类型
  void _drawType() {
    if (result is DaXianResult) {
      result == DaXianResult;
      _name = result.name.substring(5);
    }
    _parses = DrawParse.daXian(result);
  }
}
