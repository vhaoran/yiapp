import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/15 14:29
// usage ：大师好评率、差评率
// ------------------------------------------------------

class MasterRate extends StatelessWidget {
  List<String> titles; // 上层数据
  List<String> subtitles; // 下面说明文字
  final double titleSize;
  final double subSize;
  final Color backGroundColor;
  final Color titleColor; // 数据颜色
  final Color subColor; // 备注颜色

  MasterRate({
    @required this.titles,
    @required this.subtitles,
    this.titleSize: 16,
    this.subSize: 14,
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
          titles.length,
          (i) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38, width: 0.3),
            ),
            width: S.screenW() / titles.length,
            child: Column(
              children: <Widget>[
                Text(
                  titles[i],
                  style:
                      TextStyle(color: titleColor, fontSize: S.sp(titleSize)),
                ),
                Text(
                  subtitles[i],
                  style: TextStyle(color: subColor, fontSize: S.sp(subSize)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
