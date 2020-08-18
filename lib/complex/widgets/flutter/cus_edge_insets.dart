import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/18 17:23
// usage ：自定义的 EdgeInsets
// ------------------------------------------------------

class CusEdgeInsets extends EdgeInsets {
  double left;
  double top;
  double right;
  double bottom;

  CusEdgeInsets.only({
    this.left,
    this.top,
    this.right,
    this.bottom,
  }) : super.only() {
    this.left = Adapt.px(this.left ?? 0);
    this.top = Adapt.px(this.top ?? 0);
    this.right = Adapt.px(this.right ?? 0);
    this.bottom = Adapt.px(this.bottom ?? 0);
  }

  CusEdgeInsets.all(double value)
      : left = Adapt.px(value),
        top = Adapt.px(value),
        right = Adapt.px(value),
        bottom = Adapt.px(value),
        super.all(0);
}
