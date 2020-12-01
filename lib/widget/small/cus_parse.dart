import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 11:06
// usage ：封装的解析内容后的组件
// ------------------------------------------------------

class ParseContent extends StatelessWidget {
  final String title;
  final List<String> contents;
  final IconData icon;

  ParseContent({
    this.title: "",
    this.contents: const [],
    this.icon: FontAwesomeIcons.envira,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(15), bottom: Adapt.px(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: t_yi, size: Adapt.px(30)),
              Text(
                "  $title",
                style: TextStyle(color: t_yi, fontSize: Adapt.px(32)),
              ),
            ],
          ),
          SizedBox(height: Adapt.px(10)),
          ...contents.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: Adapt.px(10)),
              child: Text(
                e,
                style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
              ),
            ),
          ),
          SizedBox(height: Adapt.px(30)),
          Divider(thickness: 0.3, height: 0, color: t_gray),
        ],
      ),
    );
  }

  /// 剔除传入的数据中一些指定符号，如〖 〗
  List<String> _weedOut(List<String> l) {
    List<String> tl = [];
    l.forEach((e) {
      String str = "";
      if (e.contains("〖") && e.contains("〗")) {
        str = e.replaceAll("〖", "").replaceAll("〗", "");
      }
      tl.add(str.isEmpty ? e : str);
    });
    return tl;
  }
}
