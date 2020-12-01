import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../func/const/const_color.dart';
import '../../../func/adapt.dart';
import '../../../service/api/api_image.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/11 17:14
// usage ：自定义头像,调整 borderRadius 的值来设置方形或者圆形
// ------------------------------------------------------

class CusAvatar extends StatelessWidget {
  final String url; // 头像地址
  final double size; // 头像尺寸
  final double borderRadius;
  final int sign; // 标记，如头像右上角的未读消息个数
  final int rate;
  final String defaultImage; // 指定默认图片
  final bool circle; // 是否圆形头像，默认 false
  final BoxFit boxFit;

  CusAvatar({
    this.url: "",
    this.size: 80,
    this.borderRadius: 100,
    this.sign,
    this.rate: 4,
    this.defaultImage: "assets/images/avatar.jpg",
    this.circle: false,
    this.boxFit: BoxFit.cover,
    Key key,
  })  : assert(size > 4),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Align(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(circle ? borderRadius : size / rate),
              child: CachedNetworkImage(
                fit: boxFit,
                imageUrl: "${ApiImage.thumbnail(
                  url ?? "", // 缩略图头像
                  width: size.toInt(),
                  height: size.toInt(),
                )}",
                placeholder: (context, url) => _errImage(),
                errorWidget: (context, url, error) => _errImage(),
              ),
            ),
          ),
          // 标记符号有值时，显示标记
          if (sign != null && sign > 0)
            Positioned(
              left: size - 10,
              top: -5,
              child: ClipOval(
                child: Container(
                  height: 16,
                  width: 16,
                  color: CusColors.systemRed(context),
                  alignment: Alignment.center,
                  child: Text(
                    '${sign > 99 ? '99+' : sign}',
                    style: TextStyle(
                      fontSize: Adapt.px(16),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 错误图片
  Widget _errImage() => Image.asset(defaultImage, width: size, height: size);
}
