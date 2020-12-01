import 'package:flutter/material.dart';
import 'badge_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午6:47
// usage ：自定义底部导航栏文字描述上方组件（含Icon和通知红点）
// ------------------------------------------------------

class SuBadge extends StatefulWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;
  final bool hidden;
  final double radius; // 每个形状都有默认半径，如果设置radius，则shape属性无效
  final Widget child;
  final SuBadgeShape shape;
  final SuBadgePosition position;

  SuBadge({
    this.text,
    this.color = Colors.red,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 8),
    this.hidden = false,
    this.radius = BadgeRadius.def_radius,
    @required this.child,
    this.shape = SuBadgeShape.circle,
    this.position = SuBadgePosition.topRight,
    Key key,
  })  : assert(child != null),
        super(key: key);

  @override
  State<SuBadge> createState() => SuBadgeState();
}

class SuBadgeState extends State<SuBadge> {
  @override
  Widget build(BuildContext context) {
    SuBadgeShape shape = widget.text != null ? widget.shape : SuBadgeShape.spot;
    double size = shape == SuBadgeShape.spot
        ? 2 * BadgeRadius.spot_radius
        : BadgeRadius.badge_size;
    Widget textChild = widget.text == null
        ? null
        : Center(
            child: Text(
              widget.text,
              style: widget.textStyle,
              textAlign: TextAlign.center,
            ),
          );

    var left, right, top, bottom;
    double offset = size / 3;
    Alignment alignment;
    if (widget.position == SuBadgePosition.topRight) {
      right = -offset;
      top = -offset;
      alignment = Alignment.topRight;
    } else if (widget.position == SuBadgePosition.topLeft) {
      left = -offset;
      top = -offset;
      alignment = Alignment.topLeft;
    } else if (widget.position == SuBadgePosition.bottomRight) {
      bottom = -offset;
      right = -offset;
      alignment = Alignment.bottomRight;
    } else {
      // bottom left
      left = -offset;
      bottom = -offset;
      alignment = Alignment.bottomLeft;
    }

    Widget badge = Positioned(
        left: left,
        top: top,
        bottom: bottom,
        right: right,
        width: size,
        height: size,
        child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: _borderRadius(shape),
            ),
            child: textChild));

    List<Widget> children =
        widget.hidden ? [widget.child] : [widget.child, badge];

    return Stack(
        alignment: alignment, overflow: Overflow.visible, children: children);
  }

  BorderRadius _borderRadius(SuBadgeShape shape) {
    double radius = 0;
    if (widget.radius != BadgeRadius.def_radius)
      radius = widget.radius;
    else if (widget.shape == SuBadgeShape.circle)
      radius = BadgeRadius.badge_size / 2;
    else if (widget.shape == SuBadgeShape.square)
      radius = BadgeRadius.square_radius;
    else if (widget.shape == SuBadgeShape.spot)
      radius = BadgeRadius.spot_radius;
    print(">>>radius:$radius");
    return BorderRadius.circular(radius);
  }
}
