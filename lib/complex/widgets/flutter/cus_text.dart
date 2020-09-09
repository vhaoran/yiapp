import 'package:flutter/material.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/9 16:14
// usage ：仅针对设置文字颜色。大小的Text
// ------------------------------------------------------

class CusText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;

  const CusText(this.text, this.color, this.fontSize, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: Adapt.px(fontSize)),
    );
  }
}
