import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/luck/widget/free_content.dart';
import 'package:yiapp/model/free/con_result.dart';
import 'package:yiapp/widget/cus_button.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 10:17
// usage ：显示星座配对结果页面
// ------------------------------------------------------

class ConResPage extends StatefulWidget {
  final ConResult res;

  ConResPage({this.res, Key key}) : super(key: key);

  @override
  _ConResPageState createState() => _ConResPageState();
}

class _ConResPageState extends State<ConResPage> {
  List<Map> _l = [];

  /// 解析后的数据
  void _resData() {
    _l = [
      {
        "title": "解析",
        "contents": [widget.res.parse],
      },
      {
        "title": "爱情情缘",
        "contents": [widget.res.feel],
      },
      {
        "title": "最佳表白日",
        "contents": [widget.res.con_day.split(':')[1]],
      },
      {
        "title": "爱情誓言",
        "contents": [widget.res.oath],
      },
      {
        "title": "定情宝石",
        "contents": [widget.res.gem],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resData(); // 解析后的数据
    return Scaffold(
      appBar: CusAppBar(text: "星座配对结果"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: S.w(20)),
      children: <Widget>[
        // 什么星座男和什么星座女
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: _whoPair(widget.res.name.split('＋')),
        ),
        // 配对指数
        ...widget.res.stars.map(
          (e) => Text(
            e,
            style: TextStyle(
                color: t_primary, fontSize: S.sp(16), height: S.h(1.4)),
          ),
        ),
        SizedBox(height: S.h(10)),
        Divider(thickness: 0.3, height: 0, color: t_gray),
        // 解析
        ..._l.map(
          (e) => FreeResContent(title: e['title'], contents: e['contents']),
        ),
        CusRaisedButton(
          child: Text("重测一次"),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(height: S.h(10)),
      ],
    );
  }

  /// 什么星座男和什么星座女
  Widget _whoPair(List<String> l) {
    var male = l[0].substring(0, 2); // 白羊男 → 白羊
    var female = l[1].substring(0, 2);
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: "$male座男和$female座女",
            style: TextStyle(color: t_yi, fontSize: 16),
          ),
          TextSpan(
            text: "的星座配对指数(五星为最佳)",
            style: TextStyle(color: t_gray, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
