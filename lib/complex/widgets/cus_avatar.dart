import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../const/const_color.dart';
import '../tools/adapt.dart';
import '../../service/api/api_image.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 11:24
// usage ：头像
// ------------------------------------------------------

class CusAvatar extends StatelessWidget {
  final double size; // 头像尺寸
  final String url; // 头像地址
  final BorderRadius borderRadius;
  final int sign; // 标记，如头像右上角的未读消息个数

  CusAvatar(
    this.url, {
    Key key,
    this.size = 40,
    this.borderRadius,
    this.sign,
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
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: CusColors.systemBg(context),
                border: Border.all(color: CusColors.quaLabel(context)),
                borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
              ),
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(size / 4),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: "${ApiImage.thumbnail(url)}",
                  placeholder: (context, url) {
                    return Image.asset(
                      'assets/images/avatar.png',
                      width: size,
                      height: size,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      'assets/images/avatar.png',
                      width: size,
                      height: size,
                    );
                  },
                ),
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
}
