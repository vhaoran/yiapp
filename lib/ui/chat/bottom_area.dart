import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/func/const/const_color.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/7/1 11:45
// usage ：聊天界面底部区域（含语音、输入文字、表情、加号按钮弹出菜单选项）
// ------------------------------------------------------

class ChatBottomArea extends StatefulWidget {
  ChatBottomArea({Key key}) : super(key: key);

  @override
  _ChatBottomAreaState createState() => _ChatBottomAreaState();
}

class _ChatBottomAreaState extends State<ChatBottomArea> {
  final _msgController = TextEditingController();
  final _msgFocusNode = FocusNode();
  int _maxLines = 4;
  FocusScopeNode focusScopeNode;

  void _onSend({String msg}) {}

  /// 文字输入框
  Widget _fieldCtr() {
    TextStyle style = TextStyle(
      fontSize: 20,
      color: CusColors.label(context),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        TextSpan span = TextSpan(
            text: _msgController.text,
            style: TextStyle(
              fontSize: 20,
              color: CusColors.label(context),
            ));
        TextPainter painter = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        );
        painter.layout(maxWidth: constraints.maxWidth);

        // 向上舍入最近的整数，如 3.4 ceil 后的结果是 4
        final int lines =
            (painter.size.height / painter.preferredLineHeight).ceil();

        return TextField(
          scrollPadding: const EdgeInsets.all(0.0),
          textInputAction: TextInputAction.send,
          onSubmitted: (value) => _onSend(msg: value),
          onChanged: (v) {},
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(10.0),
            fillColor: CusColors.systemGrey6(context),
            filled: true,
          ),
          controller: _msgController,
          focusNode: _msgFocusNode,
          cursorColor: const Color(0xFF0099FF),
          maxLines: lines < _maxLines ? null : _maxLines,
          style: style,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 语音、输入框、表情、加号按钮区域
        Container(
          decoration: BoxDecoration(
            color: CusColors.systemBg(context),
            border: Border(
              top:
                  BorderSide(color: CusColors.placeholder(context), width: 0.5),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // 语音按钮
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.keyboard_voice,
                  size: 32,
                  color: const Color(0xFF868686),
                ),
              ),
              Expanded(child: _fieldCtr()),
              // 表情按钮
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.face,
                  size: 32,
                  color: const Color(0xFF868686),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    _msgFocusNode.dispose();
    super.dispose();
  }
}
