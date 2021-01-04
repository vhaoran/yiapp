import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 15:28
// usage ：单个元宝组件
// ------------------------------------------------------

class YuanBao extends StatelessWidget {
  final Color color;
  final double size;

  const YuanBao({this.color: const Color(0xFFFAE74c), this.size: 40, Key key})
      : super(key: key);

  static const IconData _iconData0 = IconData(0xe602, fontFamily: ali_font);

  @override
  Widget build(BuildContext context) {
    return Icon(_iconData0, color: color, size: Adapt.px(size));
  }
}
