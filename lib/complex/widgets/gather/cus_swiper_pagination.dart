import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 15:04
// usage ：自定义 PhotoView 中的指示器 如 1/9
// ------------------------------------------------------

class CusSwiperPagination extends SwiperPlugin {
  final Color color;
  final Color activeColor;
  final Color backgroundColor;
  final double fontSize;
  final double activeFontSize;
  final Alignment alignment;
  final Key key;

  const CusSwiperPagination({
    this.color: Colors.white,
    this.activeColor: Colors.white,
    this.backgroundColor: Colors.black38,
    this.fontSize: 18.0,
    this.activeFontSize: 18.0,
    this.alignment: const Alignment(1, 1),
    this.key,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return Align(
      alignment: alignment,
      child: Container(
        child: Row(
          key: key,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${config.activeIndex + 1}", // 当前第几张
              style: TextStyle(color: activeColor, fontSize: activeFontSize),
            ),
            Text(
              "/${config.itemCount}", // 图片总个数
              style: TextStyle(color: color, fontSize: fontSize),
            )
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(20),
          vertical: Adapt.px(10),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: backgroundColor,
        ),
      ),
    );
  }
}
