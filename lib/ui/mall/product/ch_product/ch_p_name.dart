import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/9 14:49
// usage ：修改商品名称
// ------------------------------------------------------

class ChProductName extends StatefulWidget {
  final TextEditingController nameCtrl;
  final String name;

  ChProductName({this.nameCtrl, this.name, Key key}) : super(key: key);

  @override
  _ChProductNameState createState() => _ChProductNameState();
}

class _ChProductNameState extends State<ChProductName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: <Widget>[
          CusText("商品名称", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: widget.nameCtrl,
              hintText: "请输入商品名称",
              fromValue: widget.name,
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}
