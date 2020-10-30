import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/30 17:59
// usage ：自定义聊天气泡边距
// ------------------------------------------------------

class BubbleEdges {
  final double left;
  final double top;
  final double right;
  final double bottom;

  static const BubbleEdges zero = BubbleEdges.only();

  const BubbleEdges.fromLTRB(this.left, this.top, this.right, this.bottom);

  /// 冒号后面的称为初始化列表，它是一个分离的表达式列表，可以访问构造函数参数
  /// ，并决定分配实例字段，甚至是 final 实例字段。
  /// 初始化列表也用于调用其它构造函数，如 : super(foo)
  /// 这也意外着程序列表在构造函数体之前执行，且所有超类的初始化列表都在执行任何
  /// 构造体之前执行
  const BubbleEdges.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  // 命名构造函数
  const BubbleEdges.only({
    this.left: 0,
    this.top: 0,
    this.right: 0,
    this.bottom: 0,
  });

  const BubbleEdges.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  EdgeInsets get edgeInsets =>
      EdgeInsets.fromLTRB(left ?? 0, top ?? 0, right ?? 0, bottom ?? 0);

  @override
  String toString() => 'BubbleEdges($left, $top, $right, $bottom)';
}
