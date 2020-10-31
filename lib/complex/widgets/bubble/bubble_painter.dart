import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 10:20
// usage ：绘制气泡
// ------------------------------------------------------

class BubblePainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final double elevation;
  final Color color;
  final Color shadowColor;

  BubblePainter({
    this.clipper,
    this.elevation,
    this.color,
    this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (elevation != 0) {
      canvas.drawShadow(clipper.getClip(size), shadowColor, elevation, false);
    }
    canvas.drawPath(clipper.getClip(size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
