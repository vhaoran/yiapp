import 'dart:ui';
import 'package:flutter/cupertino.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:12
// usage ：《鸿运来》App 颜色
// ------------------------------------------------------

// 背景
const Color primary = Color(0xFF302E32); // 主色调
const Color sec_primary = Color(0xFF1D1B20); // 二级背景色，比如 消息背景
const Color ter_primary = Color(0xFF332C2C); // 三级背景色，比如 AppBar
const Color fou_primary = Color(0xFF4E4141); // 四级背景色，高亮
const Color fif_primary = Color(0xFF413f42); // 五级背景色
const Color six_primary = Color(0xFF000000); // 六级背景色(待定)

// 文本
const Color t_primary = Color(0xFFFFC679); // 主文本颜色
const Color t_gray = Color(0xFFCFCFCF); // 灰白色
const Color t_green = Color(0xFF6DD400); // "在线"绿
const Color t_svip = Color(0xFFE02020); // "svip"红
const Color t_price = Color(0xFFFA6400); // "价格"橙

// 边框颜色
const Color b_border = Color(0xFF6E5A3E);

/// 系统背景
class CusColors {
  /// 一级系统背景
  static Color systemBg(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.systemBackground, context);
  }

  /// 一级分组内容背景 通用的 body 背景色
  static Color body(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.systemGroupedBackground, context);
  }

  /// 二级系统背景
  static Color secSystemBg(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemBackground, context);
  }

  static Color secSystemGroBg(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.secondarySystemGroupedBackground, context);
  }

  /// 三级系统背景 带右侧箭头的选项背景色
  static Color terSystemBg(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemBackground, context);
    // 看着和 systemBackground 同一个颜色
  }

  static Color terSystemGroBg(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemGroupedBackground, context);
  }

  /// label 黑，用于设置text
  static Color label(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.label, context);
  }

  /// label 灰，用于设置text
  static Color secLabel(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.secondaryLabel, context);
  }

  /// label 灰，用于设置text
  static Color terLabel(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.tertiaryLabel, context);
  }

  /// label 灰，用于设置text
  static Color quaLabel(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.quaternaryLabel, context);
  }

  /// 可用于Divider背景色，也可用于设置按钮颜色
  static Color placeholder(context) {
    return CupertinoDynamicColor.resolve(
        CupertinoColors.placeholderText, context);
  }

  /// 禁用按钮的颜色
  static Color disabled(context) {
    return Color.fromRGBO(235, 235, 235, 1);
  }

  /// 红色背景色
  static Color systemRed(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemRed, context);
  }

  /// 橙色背景色
  static Color systemOrange(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemOrange, context);
  }

  /// 蓝色背景色
  static Color systemBlue(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemBlue, context);
  }

  /// 灰 systemGrey
  static Color systemGrey(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemGrey, context);
  }

  /// 灰 systemGrey2
  static Color systemGrey2(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemGrey2, context);
  }

  /// 灰 systemGrey3
  static Color systemGrey3(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemGrey3, context);
  }

  /// 灰 systemGrey4
  static Color systemGrey4(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemGrey4, context);
  }

  /// 灰 systemGrey5
  static Color systemGrey5(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemGrey5, context);
  }

  /// 灰 systemGrey6
  static Color systemGrey6(context) {
    return CupertinoDynamicColor.resolve(CupertinoColors.systemGrey6, context);
  }

  /// 添加管理员时按钮禁用色
  static Color disColor = Color.fromARGB(255, 229, 229, 234);
}
