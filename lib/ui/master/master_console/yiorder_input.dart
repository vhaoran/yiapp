import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 下午7:27
// usage ：大师订单输入框
// ------------------------------------------------------

class YiOrderInput extends StatefulWidget {
  YiOrderInput({Key key}) : super(key: key);

  @override
  _YiOrderInputState createState() => _YiOrderInputState();
}

class _YiOrderInputState extends State<YiOrderInput> {
  var _replyCtrl = TextEditingController();
  var _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Container(child: _input(), color: Colors.grey),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: t_yi,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "发送",
                style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
              ),
              padding: EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }

  /// 回复内容输入框
  Widget _input() {
    return LayoutBuilder(
      builder: (context, size) {
        var text = TextSpan(
          text: _replyCtrl.text,
          style: TextStyle(fontSize: S.sp(14)),
        );
        var tp = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        );
        tp.layout(maxWidth: size.maxWidth);
        final int lines = (tp.size.height / tp.preferredLineHeight).ceil();
        return TextField(
          controller: _replyCtrl,
          autofocus: false,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.black, fontSize: S.sp(14)),
          maxLines: lines < 8 ? null : 8,
          decoration: InputDecoration(
            hintText: "回复订单",
            hintStyle: TextStyle(color: Colors.black, fontSize: S.sp(14)),
            contentPadding: EdgeInsets.only(left: S.w(10)),
          ),
        );
      },
    );
  }
}
