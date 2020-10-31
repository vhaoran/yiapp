import 'package:flutter/material.dart';
import 'bubble_edges.dart';
import 'bubble_nip_pos.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 10:09
// usage ：聊天气泡风格设置
// ------------------------------------------------------

class BubbleStyle {
  final Alignment alignment;
  final BubbleEdges padding;
  final BubbleEdges margin;
  final Radius radius;
  final double elevation;
  final Color color;
  final Color shadowColor;
  final bool stick;
  final NipPosition nip;
  final double nipHeight;
  final double nipWidth;
  final double nipOffset;
  final double nipRadius;

  const BubbleStyle({
    this.alignment,
    this.padding,
    this.margin,
    this.radius,
    this.elevation,
    this.color,
    this.shadowColor,
    this.stick,
    this.nip,
    this.nipHeight,
    this.nipWidth,
    this.nipOffset,
    this.nipRadius,
  });
}
