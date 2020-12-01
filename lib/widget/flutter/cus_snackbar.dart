import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:42
// usage ：自定义 SnackBar
// ------------------------------------------------------

class CusSnackBar {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String text; // 弹出的文字内容
  final double textSize; // 文字大小
  final Color textColor; // 文字颜色
  final Color backgroundColor; // 背景颜色
  final int milliseconds; // 多少毫秒后消失

  CusSnackBar(
    BuildContext context, {
    @required this.scaffoldKey,
    this.text = '底部弹出了一条消息',
    this.textSize = 16,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.milliseconds = 1000,
  }) {
    show(context);
  }

  show(BuildContext context) {
    scaffoldKey.currentState?.removeCurrentSnackBar();
    scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontFamily: "WorkSansSemiBold",
          ),
        ),
        backgroundColor: backgroundColor,
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }
}
