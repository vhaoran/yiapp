import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import '../../util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:23
// usage ：自定义按钮
// ------------------------------------------------------

/// 自定义 RaisedButton
class CusRaisedBtn extends StatelessWidget {
  final String text; // 名称
  final double pdHor; // 水平内边距
  final double pdVer; // 垂直内边距
  final double fontSize;
  final double borderRadius; // 四周圆弧大小
  final double minWidth; // 按钮宽度
  final double height; // 按钮高度
  final Color backgroundColor; // 背景色
  final Color textColor; // 文字颜色
  final VoidCallback onPressed;

  CusRaisedBtn({
    this.text = '确定',
    this.pdHor = 0,
    this.pdVer = 20,
    this.fontSize: 30,
    this.borderRadius = 5,
    this.minWidth = 40,
    this.height: 0,
    this.backgroundColor = t_yi,
    this.textColor = Colors.white,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: Adapt.px(minWidth),
      height: Adapt.px(height),
      padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(pdHor), vertical: Adapt.px(pdVer)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      child: RaisedButton(
        onPressed: onPressed ?? () {},
        color: backgroundColor,
        elevation: 0,
        child: Text(
          text,
          style: TextStyle(
            fontSize: Adapt.px(fontSize),
            color: textColor,
          ),
        ),
      ),
    );
  }
}

/// 自定义 OutlineButton
class CusOutlineBtn extends StatelessWidget {
  final String text; // 名称
  final double pdHor; // 水平内边距
  final double pdVer; // 垂直内边距
  final double fontSize;
  final double borderRadius; // 四周圆弧大小
  final double minWidth; // 按钮宽度,默认占满屏幕
  final double height; // 按钮高度
  final Color bgColor; // 背景色
  final Color textColor; // 文字颜色
  final VoidCallback onPressed;

  CusOutlineBtn({
    this.text = '确定',
    this.pdHor = 0,
    this.pdVer = 0,
    this.fontSize,
    this.borderRadius = 5,
    this.minWidth = double.infinity,
    this.height,
    this.bgColor = Colors.lightGreen,
    this.textColor = Colors.white,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: minWidth,
      height: Adapt.px(height ?? 72),
      padding: EdgeInsets.symmetric(horizontal: pdHor, vertical: pdVer),
      shape: OutlineInputBorder(
        borderSide: BorderSide(width: 0, color: bgColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: OutlineButton(
        onPressed: onPressed ?? () {},
        color: bgColor,
        child: Text(
          text,
          style: TextStyle(
            fontSize: Adapt.px(fontSize ?? 30),
            color: textColor,
          ),
        ),
      ),
    );
  }
}

/// yiapp 中常见样式的按钮，比如"开始测试"和"立即约聊"
class CusYiBtn extends StatelessWidget {
  final String btnName;
  final VoidCallback onPressed;

  const CusYiBtn({
    this.btnName: "开始测试",
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CusRaisedBtn(
      backgroundColor: t_primary,
      textColor: Colors.black,
      fontSize: 24,
      text: btnName,
      borderRadius: 50,
      pdHor: 20,
      pdVer: 4,
      onPressed: onPressed ?? () => print(">>>点了的按钮"),
    );
  }
}
