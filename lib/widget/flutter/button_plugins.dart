import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/2 下午5:32
// usage ：自定义按钮
// ------------------------------------------------------

/// 自定义 RaisedButton
class CusBtn extends StatelessWidget {
  final Widget child;
  final double pdHor; // 水平内边距
  final double pdVer; // 垂直内边距
  final double borderRadius; // 四周圆弧大小
  final double minWidth; // 按钮宽度
  final double height; // 按钮高度
  final Color backgroundColor; // 背景色
  final VoidCallback onPressed;

  CusBtn({
    @required this.child,
    this.pdHor = 0,
    this.pdVer = 0,
    this.borderRadius = 5,
    this.minWidth = 40,
    this.height: 0,
    this.backgroundColor = t_yi,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: pdHor, vertical: pdVer),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: RaisedButton(
        onPressed: onPressed ?? () {},
        color: backgroundColor,
        elevation: 0,
        child: child,
      ),
    );
  }
}
