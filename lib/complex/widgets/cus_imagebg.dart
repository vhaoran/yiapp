import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:27
// usage ：自定义背景图(如背景墙)
// ------------------------------------------------------

class CusImageBg extends StatelessWidget {
  final double sizeW;
  final double sizeH; // 不指定高度时，默认等于宽度
  final String url;
  BoxFit boxFit;

  CusImageBg({
    @required this.sizeW,
    this.sizeH,
    this.url,
    this.boxFit: BoxFit.cover,
    Key key,
  })  : assert(sizeW != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeW,
      height: sizeH ?? sizeW,
      child: ClipRRect(
        child: CachedNetworkImage(
          fit: boxFit,
          alignment: Alignment.topCenter,
          imageUrl: url,
          placeholder: (context, url) {
            return Image.asset(
              'assets/images/bg_blue.png',
              width: sizeW,
              height: sizeH ?? sizeW,
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              'assets/images/bg_blue.png',
              width: sizeW,
              height: sizeH ?? sizeW,
            );
          },
        ),
      ),
    );
  }
}
