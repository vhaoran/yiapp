import 'package:flutter/material.dart';
import 'bubble_clipper.dart';
import 'bubble_edges.dart';
import 'bubble_painter.dart';
import 'bubble_style.dart';
import 'bubble_nip_pos.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/30 17:58
// usage ：聊天气泡
// ------------------------------------------------------

class Bubble extends StatelessWidget {
  final Widget child;
  final Color color; // 背景色
  final double elevation; // 阴影值，默认为 1
  final Color shadowColor; // 阴影颜色，默认为黑色
  final BubbleEdges margin;
  final Alignment alignment;
  final BubbleClipper bubbleClipper;

  Bubble({
    this.child,
    Radius radius,
    NipPosition nipPos,
    double nipWidth,
    double nipHeight,
    double nipOffset,
    double nipRadius,
    bool stick,
    Color color,
    double elevation,
    Color shadowColor,
    BubbleEdges padding,
    BubbleEdges margin,
    Alignment alignment,
    BubbleStyle style,
  })  : color = color ?? style?.color ?? Colors.white,
        elevation = elevation ?? style?.elevation ?? 1.0,
        shadowColor = shadowColor ?? style?.shadowColor ?? Colors.black,
        margin = BubbleEdges.only(
          left: margin?.left ?? style?.margin?.left ?? 0.0,
          top: margin?.top ?? style?.margin?.top ?? 0.0,
          right: margin?.right ?? style?.margin?.right ?? 0.0,
          bottom: margin?.bottom ?? style?.margin?.bottom ?? 0.0,
        ),
        alignment = alignment ?? style?.alignment ?? null,
        bubbleClipper = BubbleClipper(
          radius: radius ?? style?.radius ?? Radius.circular(6.0),
          nip: nipPos ?? style?.nip ?? NipPosition.no,
          nipWidth: nipWidth ?? style?.nipWidth ?? 8.0,
          nipHeight: nipHeight ?? style?.nipHeight ?? 10.0,
          nipOffset: nipOffset ?? style?.nipOffset ?? 0.0,
          nipRadius: nipRadius ?? style?.nipRadius ?? 1.0,
          stick: stick ?? style?.stick ?? false,
          padding: BubbleEdges.only(
            left: padding?.left ?? style?.padding?.left ?? 8.0,
            top: padding?.top ?? style?.padding?.top ?? 6.0,
            right: padding?.right ?? style?.padding?.right ?? 8.0,
            bottom: padding?.bottom ?? style?.padding?.bottom ?? 6.0,
          ),
        );

  @override
  Widget build(context) {
    return Container(
      alignment: alignment,
      margin: margin?.edgeInsets,
      child: CustomPaint(
        painter: BubblePainter(
          clipper: bubbleClipper,
          color: color,
          elevation: elevation,
          shadowColor: shadowColor,
        ),
        child: Container(padding: bubbleClipper.edgeInsets, child: child),
      ),
    );
  }
}
