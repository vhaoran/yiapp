import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/func/const/const_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/6 16:17
// usage ：自定义 EasyRefresh 插件的 Header 和 Footer
// ------------------------------------------------------

/// 自定义 Header
class CusHeader extends ClassicalHeader {
  final String refreshText;
  final String refreshReadyText;
  final String refreshingText;
  final String refreshedText;
  final String infoText;
  final Color bgColor;
  final Color textColor;
  final Color infoColor;
  final bool showInfo;

  CusHeader({
    this.refreshText: "下拉刷新",
    this.refreshReadyText: "释放刷新",
    this.refreshingText: "刷新中...",
    this.refreshedText: "刷新完成",
    this.infoText: "更新于 %T",
    this.bgColor: Colors.transparent,
    this.textColor: t_gray,
    this.infoColor: t_gray,
    this.showInfo: true,
  });
}

/// 自定义 Footer
class CusFooter extends ClassicalFooter {
  final String loadText;
  final String loadReadyText;
  final String loadingText;
  final String loadedText;
  final String noMoreText;
  final String infoText;
  final Color bgColor;
  final Color textColor;
  final Color infoColor;
  final bool showInfo;

  CusFooter({
    this.loadText: "上拉加载",
    this.loadReadyText: "准备加载",
    this.loadingText: "加载中...",
    this.loadedText: "我是有底线的", // 应该是 加载完成，先用这个代替
    this.noMoreText: "我是有底线的",
    this.infoText: "更新于 %T",
    this.bgColor: Colors.transparent,
    this.textColor: t_gray,
    this.infoColor: t_gray,
    this.showInfo: true,
  });
}
