import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/luck/widget/free_content.dart';
import 'package:yiapp/model/free/birth_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 10:42
// usage ：显示生日配对结果页面
// ------------------------------------------------------

class BirthResPage extends StatefulWidget {
  final BirthResult res;

  BirthResPage({this.res, Key key}) : super(key: key);

  @override
  _BirthResPageState createState() => _BirthResPageState();
}

class _BirthResPageState extends State<BirthResPage> {
  List<Map> _parses = [];

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "配对结果",
        "contents": widget.res.result,
      },
      {
        "title": "爱情誓言",
        "contents": [widget.res.oath],
      },
      {
        "title": "吉日",
        "contents": widget.res.jiRi,
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
      padding: EdgeInsets.symmetric(horizontal: S.w(20)),
      children: <Widget>[
        // 生日配吗
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            widget.res.name,
            style: TextStyle(color: t_gray, fontSize: S.sp(17)),
          ),
        ),
        // 主体内容
        ..._parses.map(
          (e) => FreeResContent(title: e['title'], contents: e['contents']),
        ),
        // 重测按钮
        CusRaisedButton(
          child: Text("重测一次", style: TextStyle(fontSize: S.sp(16))),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(height: S.h(10)),
      ],
    );
  }
}
