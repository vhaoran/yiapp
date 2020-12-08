import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/8 下午2:58
// usage ：问命中通用的背景
// ------------------------------------------------------

class QueContainer extends StatelessWidget {
  final Widget child;
  final String title;

  QueContainer({this.child, this.title, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: S.w(15)),
      margin: EdgeInsets.only(bottom: S.h(10)),
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          Text(title, style: TextStyle(color: t_yi, fontSize: S.sp(16))),
          child,
        ],
      ),
    );
  }
}
