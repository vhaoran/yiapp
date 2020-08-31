import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/cus_math.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/ui/fortune/free_calculate/com_draw_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 16:02
// usage ：通用的免费抽灵签组件
// ------------------------------------------------------

class ComDrawPage extends StatefulWidget {
  ComDrawPage({Key key}) : super(key: key);

  @override
  _ComDrawPageState createState() => _ComDrawPageState();
}

class _ComDrawPageState extends State<ComDrawPage> {
  int _random = 0; // 根据点击抽签时，由当时的秒产生的随机数
  String _title; // 传递过来的名称
  @override
  Widget build(BuildContext context) {
    _title = ModalRoute.of(context).settings.arguments ?? "";
    return Scaffold(
      appBar: CusAppBar(text: _title),
      body: ListView(
        children: <Widget>[
          InkWell(
            child: Image.asset("assets/images/qian.png"),
            onTap: () => _chooseDraw(_title),
          ),
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 选择不同的灵签
  void _chooseDraw(String drawName) {
    print(">>>dddd");
    switch (drawName) {
      case "大仙灵签":
        _daXianDraw();
        break;
      case "关公灵签":
        break;
      case "观音灵签":
        break;
      case "妈祖灵签":
        break;
      case "月老灵签":
        break;
      case "车公灵签":
        break;
      case "吕祖灵签":
        break;
      default:
        break;
    }
  }

  void _daXianDraw() async {
    var m = {"num": CusMath.random()};
//    try {
//      var res = await ApiFree.daXianDraw(m);
//      print(">>>黄大仙灵签结果：${res.toJson()}");
//      if (res != null) {
//        CusRoutes.push(context, ComDrawResPage(result: res, title: _title));
//      }
//    } catch (e) {
//      print("<<<黄大仙灵签出现异常：$e");
//    }
  }
}
