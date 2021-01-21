import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午10:56
// usage ：帖子通用的按钮样式
// ------------------------------------------------------

class PostComButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  PostComButton({this.text, this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CusRaisedButton(
      child: Text(text, style: TextStyle(fontSize: S.sp(14))),
      padding: EdgeInsets.symmetric(vertical: S.h(6), horizontal: S.w(15)),
      onPressed: onPressed,
      borderRadius: 50,
      backgroundColor: primary,
    );
  }
}
