import 'package:flutter/material.dart';

class BubblePainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final Color color;
  final double elevation;
  final Color shadowColor;

  BubblePainter({
    this.clipper,
    this.color,
    this.elevation,
    this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (elevation != 0.0) {
      canvas.drawShadow(clipper.getClip(size), shadowColor, elevation, false);
    }
    canvas.drawPath(clipper.getClip(size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}