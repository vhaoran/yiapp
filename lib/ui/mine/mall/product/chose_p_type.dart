import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/small/fn_wrap_dialog.dart';
import 'package:yiapp/model/dicts/ProductCate.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/7 17:21
// usage ：选择商品类别
// ------------------------------------------------------

class ChoseProductType extends StatefulWidget {
  final List<Category> l;

  ChoseProductType({this.l, Key key}) : super(key: key);

  @override
  _ChoseProductTypeState createState() => _ChoseProductTypeState();
}

class _ChoseProductTypeState extends State<ChoseProductType> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Adapt.px(30)),
      margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
      decoration: BoxDecoration(
          color: fif_primary, borderRadius: BorderRadius.circular(10)),
      child: _buildView(),
    );
  }

  Widget _buildView() {
    return Row(
      children: <Widget>[
        CusText("商品种类", t_yi, 30),
        Expanded(
          child: CusRectField(
            hintText: "请选择商品种类",
            autofocus: false,
            hideBorder: true,
            enable: false,
          ),
        ),
        CusRaisedBtn(
          text: "选择",
          pdVer: 0,
          pdHor: 10,
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: t_gray,
          onPressed: () => FnWrapDialog(
            context,
            l: widget.l,
            fnWrap: (int selected, int current, dynamic data) {
              print(">>>选择的名称：${data.name}");
            },
          ),
        ),
      ],
    );
  }
}
