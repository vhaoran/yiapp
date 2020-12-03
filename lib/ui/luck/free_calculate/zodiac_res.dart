import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/ui/luck/widget/free_content.dart';
import 'package:yiapp/model/free/zodiac_result.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 10:51
// usage ：显示生肖配对结果页面
// ------------------------------------------------------

class ZodiacResPage extends StatefulWidget {
  final ZodiacResult res;

  ZodiacResPage({this.res, Key key}) : super(key: key);

  @override
  _ZodiacResPageState createState() => _ZodiacResPageState();
}

class _ZodiacResPageState extends State<ZodiacResPage> {
  List<Map> _parses = [];

  List<Map> _titles = [];

  /// 设置解析后的数据
  void _resData() {
    _parses = [
      {
        "title": "配对结果",
        "contents": widget.res.result,
      },
      {
        "title": "爱情情缘",
        "contents": [widget.res.qing_yuan],
      },
      {
        "title": "最佳表白日",
        "contents": [widget.res.biao_bai.split(':')[1]],
      },
      {
        "title": "爱情誓言",
        "contents": [widget.res.oath],
      },
      {
        "title": "定情花",
        "contents": widget.res.flower,
      },
      {
        "title": "定情宝石",
        "contents": [widget.res.gem],
      },
    ];

    _titles = [
      {"text": "属", "color": t_gray},
      {"text": widget.res.name.substring(1, 2), "color": t_yi},
      {"text": "的男的和属", "color": t_gray},
      {"text": widget.res.name.substring(7, 8), "color": t_yi},
      {"text": "的女的配吗 ？", "color": t_gray},
    ];
  }

  @override
  Widget build(BuildContext context) {
    _resData(); // 设置解析后的数据
    return Scaffold(
      appBar: CusAppBar(text: "生肖配对结果"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: S.w(20)),
      children: <Widget>[
        // 标题
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: RichText(
            text: TextSpan(children: <InlineSpan>[
              ..._titles.map(
                (e) => TextSpan(
                  text: e['text'],
                  style: TextStyle(color: e['color'], fontSize: 17),
                ),
              )
            ]),
          ),
        ),
        // 解析生肖配对数据
        ..._parses.map(
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
}
