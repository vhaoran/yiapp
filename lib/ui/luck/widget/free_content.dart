import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 11:06
// usage ：解析免费内容结果的组件
// ------------------------------------------------------

class FreeResContent extends StatelessWidget {
  final String title;
  final List<String> contents;

  FreeResContent({
    this.title: "",
    this.contents: const [],
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: S.h(10)),
      child: _column(),
    );
  }

  Widget _column() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.envira, color: t_yi, size: S.w(18)),
            Text(
              "  $title",
              style: TextStyle(color: t_yi, fontSize: S.sp(18)),
            ),
          ],
        ),
        ...contents.map(
          (e) => Padding(
            padding: EdgeInsets.symmetric(vertical: S.h(5)),
            child: Text(
              e,
              style: TextStyle(
                  color: t_gray, fontSize: S.sp(16), height: S.h(1.4)),
            ),
          ),
        ),
        SizedBox(height: S.h(15)),
        Divider(thickness: 0.3, height: 0, color: t_gray),
      ],
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
