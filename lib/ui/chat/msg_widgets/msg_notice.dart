import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/bubble/bubble.dart';
import 'package:yiapp/widget/bubble/bubble_nip_pos.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 11:01
// usage ：通知类型消息组件
// ------------------------------------------------------

class NoticeMsg extends StatelessWidget {
  final dynamic body;
  final bool mine;

  const NoticeMsg({
    this.body,
    this.mine = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bubble(
      color: CusColors.terSystemBg(context),
      nipRadius: 5,
      alignment: mine ? Alignment.topRight : Alignment.topLeft,
      nipWidth: 30,
      nipHeight: 10,
      nipPos: mine ? NipPosition.rightTop : NipPosition.leftTop,
      child: Text(
        '$body',
        style: TextStyle(
          color: CusColors.label(context),
          fontSize: 18,
        ),
      ),
    );
  }
}
