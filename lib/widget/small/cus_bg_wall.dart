import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/service/api/api_image.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/12 14:29
// usage ：背景墙
// ------------------------------------------------------

class BackgroundWall extends StatelessWidget {
  final String url;
  final double height;
  final BoxFit boxFit;
  final VoidCallback onTap;

  const BackgroundWall({
    this.url: "",
    this.height: 360,
    this.boxFit: BoxFit.cover,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints.expand(height: S.h(height)),
        child: CachedNetworkImage(
          imageUrl: "${ApiImage.thumbnail(
            url,
            height: 360.toInt(),
            width: 460.toInt(),
          )}",
          fit: boxFit,
          placeholder: (context, url) => _errImage(),
          errorWidget: (context, url, error) => _errImage(),
        ),
      ),
    );
  }

  /// 错误图片提示
  Widget _errImage() {
    return Image.asset("assets/images/bg.jpg", fit: boxFit);
  }
}
