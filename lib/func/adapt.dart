import 'dart:ui';
import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:08
// usage ：屏幕自适应
// ------------------------------------------------------

class Adapt {
  // Flutter 中控件的高宽和字体大小时，使用的是逻辑像素，并非是实际的物理像素，
  // 实际像素 = 逻辑像素 * MediaQuery.devicePixelRatio

  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

  // 用逻辑像素表示的屏幕宽度
  static double _width = mediaQuery.size.width;

  // 用逻辑像素表示的屏幕高度
  static double _height = mediaQuery.size.height;

  // 屏幕上部被系统UI遮挡的部分的逻辑高度（即：状态栏高度）
  static double _topBarH = mediaQuery.padding.top;

  static double _botBarH = mediaQuery.padding.bottom;

  // 每一个逻辑像素点对应的物理像素点个数
  static double _pixelRatio = mediaQuery.devicePixelRatio;

  static var _ratio;

  // 默认750设计图，计算真实像素值，实际尺寸 = UI 尺寸 * 设备宽度 / 设计图宽度
  static init(int number) {
    int uiWidth = number is int ? number : 750;
    _ratio = _width / uiWidth;
  }

  static px(number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init(750);
    }
    return number * _ratio;
  }

  // 1px像素大小
  static onePx() => 1 / _pixelRatio;

  static screenW() => _width;

  static screenH() => _height;

  static padTopH() => _topBarH;

  static padBotH() => _botBarH;
}
