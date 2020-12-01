import 'package:flutter/material.dart';
import 'dart:math';
import 'bubble_edges.dart';
import 'bubble_nip_pos.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 10:30
// usage ：控制聊天气泡中的布局详情，如后缀尾巴位置，偏移等
// ------------------------------------------------------

class BubbleClipper extends CustomClipper<Path> {
  final Radius radius;
  final BubbleEdges padding;
  final bool stick;
  final NipPosition nip;
  final double nipHeight;
  final double nipWidth;
  final double nipOffset; // 控制气泡尾巴在气泡上的偏移量
  final double nipRadius;
  double _startOffset; // Offsets of the bubble
  double _endOffset;
  double _nipCX; // The center of the circle
  double _nipCY;
  double _nipPX; // The point of contact of the nip with the circle
  double _nipPY;

  BubbleClipper({
    this.radius,
    this.padding,
    this.stick,
    this.nip,
    this.nipHeight,
    this.nipWidth,
    this.nipOffset,
    this.nipRadius,
  })  : assert(nipWidth > 0),
        assert(nipHeight > 0),
        assert(nipRadius >= 0),
        assert(nipRadius <= nipWidth / 2 && nipRadius <= nipHeight / 2),
        assert(nipOffset >= 0),
        assert(padding != null),
        assert(padding.left != null),
        assert(padding.top != null),
        assert(padding.right != null),
        assert(padding.bottom != null),
        //  assert(radius <= nipHeight + nipOffset),
        super() {
    _startOffset = _endOffset = nipWidth;

    var k = nipHeight / nipWidth;
    var a = atan(k);

    _nipCX = (nipRadius + sqrt(nipRadius * nipRadius * (1 + k * k))) / k;
    var nipStickOffset = (_nipCX - nipRadius).floorToDouble();

    _nipCX -= nipStickOffset;
    _nipCY = nipRadius;
    _nipPX = _nipCX - nipRadius * sin(a);
    _nipPY = _nipCY + nipRadius * cos(a);
    _startOffset -= nipStickOffset;
    _endOffset -= nipStickOffset;

    if (stick) _endOffset = 0;
  }

  get edgeInsets {
    return nip == NipPosition.leftTop ||
            nip == NipPosition.leftBottom ||
            nip == NipPosition.leftCenter
        ? EdgeInsets.only(
            left: _startOffset + padding.left,
            top: padding.top,
            right: _endOffset + padding.right,
            bottom: padding.bottom)
        : nip == NipPosition.rightTop || nip == NipPosition.rightBottom
            ? EdgeInsets.only(
                left: _endOffset + padding.left,
                top: padding.top,
                right: _startOffset + padding.right,
                bottom: padding.bottom)
            : EdgeInsets.only(
                left: _endOffset + padding.left,
                top: padding.top,
                right: _endOffset + padding.right,
                bottom: padding.bottom);
  }

  @override
  Path getClip(Size size) {
    var radiusX = radius.x;
    var radiusY = radius.y;
    var maxRadiusX = size.width / 2;
    var maxRadiusY = size.height / 2;

    if (radiusX > maxRadiusX) {
      radiusY *= maxRadiusX / radiusX;
      radiusX = maxRadiusX;
    }
    if (radiusY > maxRadiusY) {
      radiusX *= maxRadiusY / radiusY;
      radiusY = maxRadiusY;
    }

    var path = Path();

    // 控制聊天气泡后缀尾巴上的位置
    switch (nip) {
      // 左上
      case NipPosition.leftTop:
        path.addRRect(
          RRect.fromLTRBR(
              _startOffset, 0, size.width - _endOffset, size.height, radius),
        );
        path.moveTo(_startOffset + radiusX, nipOffset);
        path.lineTo(_startOffset + radiusX, nipOffset + nipHeight);
        path.lineTo(_startOffset, nipOffset + nipHeight);
        if (nipRadius == 0) {
          path.lineTo(0, nipOffset);
        } else {
          path.lineTo(_nipPX, nipOffset + _nipPY);
          path.arcToPoint(Offset(_nipCX, nipOffset),
              radius: Radius.circular(nipRadius));
        }
        path.close();
        break;
      // 左中
      case NipPosition.leftCenter:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));
        path.moveTo(_startOffset + radiusX, size.height / 2 - nipHeight);
        path.lineTo(_startOffset + radiusX, size.height / 2 + nipHeight);
        path.lineTo(_startOffset, size.height / 2 + nipHeight);
        if (nipRadius == 0) {
          path.lineTo(0, size.height / 2 + nipHeight);
        } else {
          path.lineTo(_nipPX, size.height / 2 + _nipPY);
          path.arcToPoint(Offset(_nipCX, nipOffset + size.height / 2),
              radius: Radius.circular(nipRadius));
        }
        path.close();
        break;
      // 左下
      case NipPosition.leftBottom:
        path.addRRect(RRect.fromLTRBR(
            _startOffset, 0, size.width - _endOffset, size.height, radius));
        Path path2 = Path();
        path2.moveTo(_startOffset + radiusX, size.height - nipOffset);
        path2.lineTo(
            _startOffset + radiusX, size.height - nipOffset - nipHeight);
        path2.lineTo(_startOffset, size.height - nipOffset - nipHeight);
        if (nipRadius == 0) {
          path2.lineTo(0, size.height - nipOffset);
        } else {
          path2.lineTo(_nipPX, size.height - nipOffset - _nipPY);
          path2.arcToPoint(Offset(_nipCX, size.height - nipOffset),
              radius: Radius.circular(nipRadius), clockwise: false);
        }
        path2.close();
        path.addPath(path2, Offset(0, 0));
        path.addPath(path2, Offset(0, 0)); // Magic!
        break;
      // 右上
      case NipPosition.rightTop:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));
        Path path2 = Path();
        path2.moveTo(size.width - _startOffset - radiusX, nipOffset);
        path2.lineTo(
            size.width - _startOffset - radiusX, nipOffset + nipHeight);
        path2.lineTo(size.width - _startOffset, nipOffset + nipHeight);
        if (nipRadius == 0) {
          path2.lineTo(size.width, nipOffset);
        } else {
          path2.lineTo(size.width - _nipPX, nipOffset + _nipPY);
          path2.arcToPoint(Offset(size.width - _nipCX, nipOffset),
              radius: Radius.circular(nipRadius), clockwise: false);
        }
        path2.close();
        path.addPath(path2, Offset(0, 0));
        path.addPath(path2, Offset(0, 0)); // Magic!
        break;
      // 右下
      case NipPosition.rightBottom:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _startOffset, size.height, radius));
        path.moveTo(
            size.width - _startOffset - radiusX, size.height - nipOffset);
        path.lineTo(size.width - _startOffset - radiusX,
            size.height - nipOffset - nipHeight);
        path.lineTo(
            size.width - _startOffset, size.height - nipOffset - nipHeight);
        if (nipRadius == 0) {
          path.lineTo(size.width, size.height - nipOffset);
        } else {
          path.lineTo(size.width - _nipPX, size.height - nipOffset - _nipPY);
          path.arcToPoint(Offset(size.width - _nipCX, size.height - nipOffset),
              radius: Radius.circular(nipRadius));
        }
        path.close();
        break;
      // 无
      case NipPosition.no:
        path.addRRect(RRect.fromLTRBR(
            _endOffset, 0, size.width - _endOffset, size.height, radius));
        break;
    }
    return path;
  }

  @override
  bool shouldReclip(BubbleClipper oldClipper) => false;
}
