import 'package:flutter/material.dart';

const Color _kDefaultTitleColor = const Color.fromARGB(255, 93, 100, 110);
const Color _kDefaultTitleColorLight = const Color.fromARGB(255, 247, 247, 247);
const Color _kDefaultDetailColor = const Color.fromARGB(255, 133, 140, 150);
const Color _kDefaultDetailColorLight =
    const Color.fromARGB(255, 218, 218, 218);

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/30 下午5:16
// usage ：获取数据前加载的内容
// ------------------------------------------------------

class SuFetching extends StatefulWidget {
  final Color backgroundColor;
  // 默认不显示loading，如果显示，不指定自定义的加载组件时，默认为转圈
  final bool showLoading;
  final Widget customLoadingWidget; // 自定义的加载组件
  final Image image;
  final String title;
  final TextStyle titleStyle;
  final String detailText;
  final TextStyle detailTextStyle;
  final double space;
  final Widget actionButton; // 自定义操作按钮

  SuFetching({
    this.backgroundColor,
    this.customLoadingWidget,
    this.showLoading = false,
    this.image,
    this.title,
    this.titleStyle,
    this.detailText,
    this.detailTextStyle,
    this.space = 8.0,
    this.actionButton,
    Key key,
  }) : super(key: key);

  @override
  State<SuFetching> createState() => SuFetchingState();
}

class SuFetchingState extends State<SuFetching> {
  void _addChildAndSpacingIfNeeded(List<Widget> list, Widget newChild) {
    if (list.length > 0) {
      list.add(SizedBox(height: widget.space));
    }
    list.add(newChild);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Widget> children = <Widget>[];
    if (widget.customLoadingWidget != null) {
      _addChildAndSpacingIfNeeded(children, widget.customLoadingWidget);
    }

    if (widget.customLoadingWidget == null && widget.showLoading) {
      Widget loading = CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
      );
      _addChildAndSpacingIfNeeded(children, loading);
    }

    if (widget.image != null) {
      _addChildAndSpacingIfNeeded(children, widget.image);
    }

    if (widget.title != null && widget.title.isNotEmpty) {
      TextStyle textStyle = widget.titleStyle ??
          TextStyle(
              fontSize: 16,
              color:
                  isDarkMode ? _kDefaultTitleColorLight : _kDefaultTitleColor);
      Widget title =
          Text(widget.title, style: textStyle, textAlign: TextAlign.center);
      _addChildAndSpacingIfNeeded(children, title);
    }

    if (widget.detailText != null && widget.detailText.isNotEmpty) {
      TextStyle textStyle = widget.detailTextStyle ??
          TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? _kDefaultDetailColorLight
                  : _kDefaultDetailColor);
      Widget detailText = Text(widget.detailText,
          style: textStyle, textAlign: TextAlign.center);
      _addChildAndSpacingIfNeeded(children, detailText);
    }

    if (widget.actionButton != null) {
      _addChildAndSpacingIfNeeded(children, widget.actionButton);
    }

    return Container(
      color: widget.backgroundColor,
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
