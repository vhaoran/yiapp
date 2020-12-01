import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/10 16:09
// usage ：自定义上面一个圆形图标、下面文字备注
// ------------------------------------------------------

class CusCircleItem extends StatelessWidget {
  final int icon; // 图标
  final String text; // 文字描述
  final double height; // 图片高度
  final double fontSize; // 文字大小
  final double top; // 文字距离图片的距离
  final Color color; // 文字颜色
  final int bgColor; // 图标颜色
  final VoidCallback onTap;

  CusCircleItem({
    this.icon: 0xe615,
    this.text: "默认文字",
    this.height: 90,
    this.fontSize: 24,
    this.top: 12,
    this.color: t_gray,
    this.bgColor: 0xFFF0B36E,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          ClipOval(
            child: Container(
              height: Adapt.px(height),
              width: Adapt.px(height),
              color: Color(bgColor),
              child: Icon(
                IconData(icon, fontFamily: ali_font),
                size: Adapt.px(80),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(top)),
            child: Text(
              text,
              style: TextStyle(fontSize: Adapt.px(fontSize), color: color),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
