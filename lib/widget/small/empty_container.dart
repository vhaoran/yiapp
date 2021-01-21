import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午11:20
// usage ：没有数据时，通用的提示组件
// ------------------------------------------------------

class EmptyContainer extends StatelessWidget {
  final String text;

  EmptyContainer({@required this.text, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: S.screenH() / 4),
      child: Text(
        text,
        style: TextStyle(color: t_gray, fontSize: S.sp(16)),
      ),
    );
  }
}
