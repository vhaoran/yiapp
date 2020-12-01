import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 15:28
// usage ：单个元宝组件
// ------------------------------------------------------

class YuanBaoCtr extends StatelessWidget {
  final int iconData;
  final Color color;
  final double size;

  const YuanBaoCtr({
    this.iconData: 0xe602,
    this.color: const Color(0xFFFAE74c),
    this.size: 40,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      IconData(iconData, fontFamily: ali_font),
      color: color,
      size: Adapt.px(size),
    );
  }
}
