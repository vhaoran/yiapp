import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/widget/cus_dot_format.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/bo/price_level_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 09:58
// usage ：我要提问 - 设置悬赏金
// ------------------------------------------------------

class PostScoreInput extends StatefulWidget {
  final TextEditingController controller;
  final List<PriceLevelRes> l;

  PostScoreInput({this.controller, this.l, Key key}) : super(key: key);

  @override
  _PostScoreInputState createState() => _PostScoreInputState();
}

class _PostScoreInputState extends State<PostScoreInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: _row(),
    );
  }

  Widget _row() {
    return Row(
      children: <Widget>[
        CusText("选择悬赏金额", t_yi, 30),
        Expanded(
          child: CusRectField(
            controller: widget.controller,
            hintText: "请输入$yuan_bao金额",
            autofocus: false,
            hideBorder: true,
            onlyNumber: true,
            inputFormatters: [DotFormatter()],
          ),
        ),
      ],
    );
  }
}
