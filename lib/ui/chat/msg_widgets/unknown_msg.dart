import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/model/msg/msg_body.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 10:45
// usage ：未知消息类型的处理
// ------------------------------------------------------

class UnknownMsg extends StatelessWidget {
  final MsgBody msg;

  const UnknownMsg(this.msg);

  @override
  Widget build(BuildContext context) {
    return Text('未知消息类型：$msg');
  }
}
