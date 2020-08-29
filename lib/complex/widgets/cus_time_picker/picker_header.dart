import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/29 14:48
// usage ：顶部标题，含取消或者确定按钮
// ------------------------------------------------------

class PickerHeader extends StatelessWidget {
  final Widget midChild; // 中间可扩展的组件
  final VoidCallback onFirm; // 确认后的事件

  const PickerHeader({
    this.midChild,
    @required this.onFirm,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(color: Color(0xFF999999), fontSize: 15),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            if (midChild != null) midChild,
            FlatButton(
              child: Text(
                '确认',
                style: TextStyle(
                    color: CusColors.systemBlue(context), fontSize: 15),
              ),
              onPressed: onFirm,
            ),
          ],
        ),
        Divider(thickness: 0.3, height: 0, color: Color(0xFF999999)),
      ],
    );
  }
}
