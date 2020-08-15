import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/15 14:29
// usage ：自定义数据组件，如好评率、粉丝数等
// ------------------------------------------------------

class CusNumData extends StatelessWidget {
  final int count; // 默认生成个数
  final String title; // 数据
  final String subtitle; // 说明
  final double titleSize;
  final double subSize;
  final Color backGroundColor;
  final Color titleColor; // 数据颜色
  final Color subColor; // 备注颜色

  const CusNumData({
    this.count: 3,
    this.title: "12590",
    this.subtitle: "好评率",
    this.titleSize: 32,
    this.subSize: 24,
    this.backGroundColor: fif_primary,
    this.titleColor: t_primary,
    this.subColor: t_gray,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor,
      child: Row(
        children: List.generate(
          count,
          (index) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 0.3),
            ),
            padding: EdgeInsets.symmetric(vertical: Adapt.px(5)),
            width: Adapt.screenW() / count,
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: titleColor, fontSize: Adapt.px(titleSize)),
                ),
                Text(
                  subtitle,
                  style:
                      TextStyle(color: subColor, fontSize: Adapt.px(subSize)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
