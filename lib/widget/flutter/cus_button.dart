import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import '../../util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:23
// usage ：自定义按钮
// ------------------------------------------------------

/// 自定义 RaisedButton
class CusBtn extends StatelessWidget {
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

  CusBtn({
    this.text = '确定',
    this.pdHor = 0,
    this.pdVer = 5,
    this.fontSize: 16,
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
      minWidth: S.w(minWidth),
      height: S.h(height),
      padding:
          EdgeInsets.symmetric(horizontal: S.w(pdHor), vertical: S.h(pdVer)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      child: RaisedButton(
        onPressed: onPressed ?? () {},
        color: backgroundColor,
        elevation: 0,
        child: Text(
          text,
          style: TextStyle(fontSize: S.sp(fontSize), color: textColor),
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
    return CusBtn(
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
