import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 17:15
// usage ：CusSelect 选择星座、生肖等的通用组件
// ------------------------------------------------------

class CusSelect extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CusSelect({
    this.title: "默认标题：",
    this.subtitle: "请选择类型",
    this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        ),
        SizedBox(width: Adapt.px(10)),
        InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: Adapt.px(50),
                width: Adapt.px(360),
                padding: EdgeInsets.symmetric(horizontal: Adapt.px(90)),
                child: Text(
                  subtitle,
                  style: TextStyle(color: t_yi, fontSize: Adapt.px(30)),
                ),
                decoration: BoxDecoration(
                  color: fif_primary,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: Adapt.px(50),
                child: Icon(FontAwesomeIcons.angleDown, size: Adapt.px(45)),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.grey),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


