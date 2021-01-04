import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 11:22
// usage ：配对描述组件，如星座配对信息
// ------------------------------------------------------

class PairDescription extends StatelessWidget {
  final IconData iconData; // 配对图标
  final String name; // 配对名称
  final String desc; // 描述信息

  const PairDescription({
    this.iconData,
    this.name: "",
    this.desc: "",
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(iconData, size: S.w(50), color: t_yi),
        SizedBox(width: S.w(10)),
        _desc(), // 描述文字
      ],
    );
  }

  /// 描述文字
  Widget _desc() {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: name,
              style: TextStyle(color: t_yi, fontSize: 16, height: S.h(1.3)),
            ),
            TextSpan(
              text: desc,
              style: TextStyle(color: t_gray, fontSize: 16, height: S.h(1.3)),
            ),
          ],
        ),
      ),
    );
  }
}
