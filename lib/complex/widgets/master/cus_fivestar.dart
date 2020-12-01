import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/19 09:55
// usage ：自定义五角星
// ------------------------------------------------------

class FiveStars extends StatelessWidget {
  final int count; // 生成五角星个数
  final IconData icon;
  final Color color;
  final double size;
  final double space; // 相邻五角星间隔

  const FiveStars({
    this.count: 5,
    this.icon: FontAwesomeIcons.solidStar,
    this.color: t_primary,
    this.size: 28,
    this.space: 10,
    Key key,
  })  : assert(count >= 1 && count <= 5),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(right: Adapt.px(space)),
          child: Icon(icon, color: color, size: Adapt.px(size)),
        ),
      ),
    );
  }
}
