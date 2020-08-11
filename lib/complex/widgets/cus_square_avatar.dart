import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../const/const_color.dart';
import '../tools/adapt.dart';
import '../../service/api/api_image.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/11 17:14
// usage ：自定义方形头像
// ------------------------------------------------------

class CusSquareAvatar extends StatelessWidget {
  final String url; // 头像地址
  final double size; // 头像尺寸
  final double borderRadius;
  final int sign; // 标记，如头像右上角的未读消息个数

  CusSquareAvatar({
    @required this.url,
    this.size: 40,
    this.borderRadius,
    this.sign,
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
              borderRadius: BorderRadius.circular(borderRadius ?? size / 4),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "${ApiImage.thumbnail(url)}",
                placeholder: (context, url) {
                  return Image.asset(
                    'assets/images/temp_wrong.jpg',
                    width: size,
                    height: size,
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/temp_wrong.jpg',
                    width: size,
                    height: size,
                  );
                },
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
