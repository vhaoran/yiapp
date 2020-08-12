import 'dart:io';
import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/12 19:01
// usage ：自定义 behavior ，用于取消 ListView 中的底部回弹蓝色效果
// ------------------------------------------------------

class CusBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    }
    return super.buildViewportChrome(context, child, axisDirection);
  }
}
