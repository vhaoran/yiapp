import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 18:21
// usage ：自定义的选项组件(上面Icon，下面Text组件,带背景，如发送位置、选择图片)
// ------------------------------------------------------

class CusOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const CusOption({
    this.title: "待定",
    this.icon: Icons.broken_image,
    this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        InkWell(
          onTap: onPressed,
          child: Container(
            decoration: new BoxDecoration(
              color: CusColors.terSystemBg(context),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.all(10),
            child: Icon(
              icon ?? Icons.access_alarm,
              color: Colors.black54,
              size: 30,
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(color: t_primary),
        ),
      ],
    );
  }
}
