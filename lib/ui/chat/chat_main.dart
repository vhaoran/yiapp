import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/chat/chat_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 11:25
// usage ：聊天入口
// ------------------------------------------------------

class ChatMain extends StatelessWidget {
  ChatMain({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "消息"),
      body: ChatPage(),
      backgroundColor: primary,
    );
  }
}
