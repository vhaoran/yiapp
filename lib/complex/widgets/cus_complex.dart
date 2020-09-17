import 'dart:io';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';

/// 自定义 behavior ，用于取消 ListView 中回弹的蓝色效果
class CusBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return super.buildViewportChrome(context, child, axisDirection);
  }
}

/// 自定义 UnderlineInputBorder
InputBorder cusUnderBorder({Color color}) {
  return UnderlineInputBorder(
    borderSide: BorderSide(color: color ?? Colors.black45),
  );
}

/// 自定义 OutlineInputBorder
InputBorder cusOutlineBorder({Color color}) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: color ?? Colors.black45),
  );
}
