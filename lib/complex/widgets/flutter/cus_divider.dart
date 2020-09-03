import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/3 11:32
// usage ：自定义分割线
// ------------------------------------------------------

class CusDivider extends StatelessWidget {
  final double thickness;
  final double pdH;
  final double pdV;
  final Color color;

  const CusDivider({
    this.thickness: 0.2,
    this.pdH: 0,
    this.pdV: 20,
    this.color: t_gray,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Adapt.px(pdH),
        vertical: Adapt.px(pdV),
      ),
      child: Divider(thickness: thickness, height: 0, color: color),
    );
  }
}
