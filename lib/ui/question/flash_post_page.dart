import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/21 10:16
// usage ：闪断帖主页面
// ------------------------------------------------------

class FlashPostPage extends StatefulWidget {
  FlashPostPage({Key key}) : super(key: key);

  @override
  _FlashPostPageState createState() => _FlashPostPageState();
}

class _FlashPostPageState extends State<FlashPostPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          CusText("闪断帖", t_gray, 32),
        ],
      ),
    );
  }
}
