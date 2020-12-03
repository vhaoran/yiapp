import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/luck/widget/free_content.dart';
import 'package:yiapp/model/free/chegong_result.dart';
import 'package:yiapp/model/free/daxian_result.dart';
import 'package:yiapp/model/free/guandi_result.dart';
import 'package:yiapp/model/free/guanyin_result.dart';
import 'package:yiapp/model/free/lvzu_result.dart';
import 'package:yiapp/model/free/mazu_result.dart';
import 'package:yiapp/model/free/yuelao_result.dart';
import 'package:yiapp/ui/luck/free_calculate/draw_parse.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 18:05
// usage ：通用的灵签结果页面
// ------------------------------------------------------

class ComDrawResPage extends StatefulWidget {
  final String title;
  final dynamic result; // 动态传递的灵签类型

  ComDrawResPage({
    this.title: "灵签结果",
    this.result,
    Key key,
  }) : super(key: key);

  @override
  _ComDrawResPageState createState() => _ComDrawResPageState();
}

class _ComDrawResPageState extends State<ComDrawResPage> {
  List<Map> _parses = [];
  String _name = "";
  @override
  Widget build(BuildContext context) {
    _drawType();
    return Scaffold(
      appBar: CusAppBar(text: widget.title),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: S.w(20)),
        children: <Widget>[
          // 标题
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: S.h(5)),
            child: Text(
              _name,
              style: TextStyle(color: t_gray, fontSize: S.sp(17)),
            ),
          ),
          // 内容
          ..._parses.map(
            (e) => FreeResContent(
              title: e['title'],
              contents: e['contents'],
            ),
          ),
          // 重测按钮
          CusRaisedButton(
            child: Text("重测一次", style: TextStyle(fontSize: S.sp(16))),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(height: S.h(10)),
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 选择灵签类型
  void _drawType() {
    _name = widget.result.name.substring(5);
    // 大仙
    if (widget.result is DaXianResult) {
      _parses = DrawParse.daXian(widget.result);
    }
    // 关公
    else if (widget.result is GuanDiResult) {
      _parses = DrawParse.guanDi(widget.result);
    }
    // 观音
    else if (widget.result is GuanYinResult) {
      _parses = DrawParse.guanYin(widget.result);
    }
    // 妈祖
    else if (widget.result is MaZuResult) {
      _parses = DrawParse.maZu(widget.result);
    }
    // 月老
    else if (widget.result is YueLaoResult) {
      _parses = DrawParse.yueLao(widget.result);
    }
    // 车公
    else if (widget.result is CheGongResult) {
      _parses = DrawParse.cheGong(widget.result);
    }
    // 吕祖
    else if (widget.result is LvZuResult) {
      _parses = DrawParse.lvZu(widget.result);
    }
  }
}
