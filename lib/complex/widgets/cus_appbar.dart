import 'package:flutter/material.dart';
import '../const/const_color.dart';
import '../const/const_num.dart';
import '../tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 17:15
// usage ：自定义 AppBar
// ------------------------------------------------------

class CusAppBar extends StatelessWidget implements PreferredSizeWidget {
  CusAppBar({
    Key key,
    this.title,
    this.leading,
    this.showLeading = true,
    this.color = ter_primary,
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
          style: TextStyle(color: t_primary, fontSize: Adapt.px(34)),
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
