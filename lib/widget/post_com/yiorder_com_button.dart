import 'package:flutter/material.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/26 上午9:41
// usage ：大师订单通用的按钮
// ------------------------------------------------------

class YiOrderComButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  YiOrderComButton({this.text, this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CusRaisedButton(
      padding: EdgeInsets.symmetric(vertical: S.h(6), horizontal: S.w(15)),
      child: Text(text, style: TextStyle(fontSize: S.sp(14))),
      onPressed: onPressed,
      borderRadius: 50,
      backgroundColor: Colors.lightBlue,
    );
  }
}
