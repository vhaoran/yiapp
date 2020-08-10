import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/10 16:09
// usage ：自定义上面一个圆形图标、下面文字备注
// ------------------------------------------------------

class CusCircleItem extends StatelessWidget {
  final String path; // 图片路径
  final String text; // 文字描述
  final double height; // 图片高度
  final double fontSize; // 文字大小
  final double top; // 文字距离图片的距离
  final Color color; // 文字颜色
  final VoidCallback onTap;

  const CusCircleItem({
    this.path: "assets/images/plate.png",
    this.text: "默认文字",
    this.height: 48,
    this.fontSize: 12,
    this.top: 2,
    this.color: t_gray,
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: height,
              child: ClipOval(child: Image.asset(path)),
            ),
            Padding(
              padding: EdgeInsets.only(top: top),
              child: Text(
                text,
                style: TextStyle(fontSize: fontSize, color: color),
              ),
            )
          ],
        ),
      ),
    );
  }
}
