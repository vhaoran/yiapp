import 'package:flutter/material.dart';
import '../const/const_num.dart';
import 'cus_function.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 10:53
// usage ：自定义组件
// ------------------------------------------------------

/// 01 自定义 AppBar
class CusAppBar extends StatelessWidget implements PreferredSizeWidget {
  CusAppBar({
    Key key,
    this.title,
    this.leading,
    this.showLeading = true,
    this.color = CusColors.bar,
    this.leadingColor = Colors.black,
    this.actions,
    this.bottom,
    this.barHeight = appBarH,
  })  : preferredSize = Size.fromHeight(barHeight),
        super(key: key);

  final String title;
  final Widget leading;
  final bool showLeading;
  final Color color; // AppBar背景色
  final Color leadingColor; // leading 背景色
  final List<Widget> actions;
  final Widget bottom;
  final num barHeight;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        title: Text(
          title ?? "",
          style: TextStyle(color: CusColors.text, fontSize: Adapt.px(34)),
        ),
        elevation: 0,
        bottom: bottom,
        actions: actions,
        centerTitle: true,
        backgroundColor: color,
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme:
            IconThemeData(size: Adapt.px(50), color: Colors.black),
        leading: showLeading
            ? leading ??
                IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios, color: leadingColor, size: 22),
                  onPressed: () => Navigator.pop(context),
                )
            : null,
      ),
    );
  }
}

// - - - - - - - - - - - - - - 按钮 - - - - - - - - - - - - - -

/// 02 自定义 RaisedButton
class CusRaisedBtn extends StatelessWidget {
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

  CusRaisedBtn({
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      child: RaisedButton(
        onPressed: onPressed ?? () {},
        color: bgColor,
        elevation: 0,
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

/// 03 自定义 OutlineButton
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
