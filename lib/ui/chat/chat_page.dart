import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/ui/chat/bottom_area.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/31 11:24
// usage ：聊天页面
// ------------------------------------------------------

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(child: _lv()),
        ChatBottomArea(),
      ],
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        CusText("这是消息", t_gray, 39),
      ],
    );
  }
}
