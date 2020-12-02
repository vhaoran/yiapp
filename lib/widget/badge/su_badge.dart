import 'package:flutter/material.dart';
import 'badge_data.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午6:47
// usage ：自定义底部导航栏文字描述上方组件（含Icon和通知红点）
// ------------------------------------------------------

// 文中提到的小红点指的通知消息，并非一定为红色
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
  double _left, _right, _top, _bottom, _size; // 控制小红点的位置和大小
  Alignment alignment;

  @override
  Widget build(BuildContext context) {
    _noticePosition();
    List<Widget> children =
        widget.hidden ? [widget.child] : [widget.child, _badge()];
    return Stack(
      alignment: alignment,
      overflow: Overflow.visible,
      children: children,
    );
  }

  Widget _badge() {
    return Positioned(
      left: _left,
      right: _right,
      top: _top,
      bottom: _bottom,
      width: _size,
      height: _size,
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: _borderRadius(),
        ),
        child: widget.text == null
            ? null
            : Center(
                child: Text(
                  widget.text,
                  style: widget.textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  /// 通知信息小红点位置
  void _noticePosition() {
    SuBadgeShape shape = widget.text != null ? widget.shape : SuBadgeShape.spot;
    _size = shape == SuBadgeShape.spot
        ? 2 * BadgeRadius.spot_radius
        : BadgeRadius.badge_size;
    double offset = _size / 3;
    switch (widget.position) {
      case SuBadgePosition.topRight:
        _right = -offset;
        _top = -offset;
        alignment = Alignment.topRight;
        break;
      case SuBadgePosition.topLeft:
        _left = -offset;
        _top = -offset;
        alignment = Alignment.topLeft;
        break;
      case SuBadgePosition.bottomRight:
        _bottom = -offset;
        _right = -offset;
        alignment = Alignment.bottomRight;
        break;
      default:
        _left = -offset;
        _bottom = -offset;
        alignment = Alignment.bottomLeft;
        break;
    }
  }

  /// 动态设置小红点的半径
  BorderRadius _borderRadius() {
    double radius = 0;
    if (widget.radius != BadgeRadius.def_radius)
      radius = widget.radius;
    else if (widget.shape == SuBadgeShape.circle)
      radius = BadgeRadius.badge_size / 2;
    else if (widget.shape == SuBadgeShape.square)
      radius = BadgeRadius.square_radius;
    else if (widget.shape == SuBadgeShape.spot)
      radius = BadgeRadius.spot_radius;
    return BorderRadius.circular(radius);
  }
}
