import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 17:13
// usage ：商品名称
// ------------------------------------------------------

class AddProductName extends StatefulWidget {
  final TextEditingController nameCtrl;

  AddProductName({this.nameCtrl, Key key}) : super(key: key);

  @override
  _AddProductNameState createState() => _AddProductNameState();
}

class _AddProductNameState extends State<AddProductName> {
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
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}
