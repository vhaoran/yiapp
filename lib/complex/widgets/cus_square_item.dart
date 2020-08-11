import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/11 10:50
// usage ：自定义上面一个方形形图标、下面文字备注
// ------------------------------------------------------

class CusSquareItem extends StatelessWidget {
  final String path; // 图片路径
  final String text; // 文字描述
  final double height; // 图片高度
  final double fontSize; // 文字大小
  final double spacing; // 文字距离图片的距离
  final double borderRadius; // 图片圆角的大小
  final Color color; // 文字颜色
  FnString onTap;

  CusSquareItem({
    this.path: "assets/images/zodiac_plate.png",
    this.text: "默认文字",
    this.height: 42,
    this.fontSize: 10,
    this.spacing: 2,
    this.borderRadius: 10,
    this.color: t_primary,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap(text);
        }
      },
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: SizedBox(
              height: height,
              width: height,
              child: Image.asset(path, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: spacing),
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, color: color),
            ),
          )
        ],
      ),
    );
  }
}
