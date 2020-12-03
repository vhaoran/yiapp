import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/luck/widget/free_content.dart';
import 'package:yiapp/model/free/blood_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 17:19
// usage ：显示血型配对结果页面
// ------------------------------------------------------

class BloodResPage extends StatefulWidget {
  final BloodResult res;

  BloodResPage({this.res, Key key}) : super(key: key);

  @override
  _BloodResPageState createState() => _BloodResPageState();
}

class _BloodResPageState extends State<BloodResPage> {
  List<Map> _parses = [];

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "彼此吸引点",
        "contents": [widget.res.advantage],
      },
      {
        "title": "最佳表白日",
        "contents": [widget.res.confession_day.split(':')[1]],
      },
      {
        "title": "可能出现的问题",
        "contents": [widget.res.disadvantage],
      },
      {
        "title": "爱情誓言",
        "contents": [widget.res.disadvantage],
      },
      {
        "title": "增进感情的方式",
        "contents": [widget.res.plus],
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
        // 什么血型
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
