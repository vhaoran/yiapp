import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 18:28
// usage ：商品的价格和颜色
// ------------------------------------------------------

class ProductColorPrice extends StatefulWidget {
  final TextEditingController colorCtrl;
  final TextEditingController priceCtrl;
  final FnBool noErr;

  ProductColorPrice({
    this.colorCtrl,
    this.priceCtrl,
    this.noErr,
    Key key,
  }) : super(key: key);

  @override
  _ProductColorPriceState createState() => _ProductColorPriceState();
}

class _ProductColorPriceState extends State<ProductColorPrice> {
  List<Map<String, dynamic>> _l = []; // 商品的颜色和价格列表
  String _err; // 错误提示信息

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Adapt.px(30)),
          margin: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          decoration: BoxDecoration(
              color: fif_primary, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: <Widget>[
              Expanded(child: Column(children: _inputs())),
              CusRaisedBtn(
                text: "添加第一种",
                pdVer: 0,
                pdHor: 10,
                fontSize: 28,
                textColor: Colors.black,
                backgroundColor: t_gray,
                onPressed: _doAdd,
              ),
            ],
          ),
        ),
        if (_err != null)
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: Adapt.px(30)),
            child: CusText(_err, t_yi, 28),
          ),
      ],
    );
  }

//  // 将商品的颜色和价格添加到列表中
  void _doAdd() {
    setState(() {
      _err = widget.colorCtrl.text.isEmpty || widget.priceCtrl.text.isEmpty
          ? "商品的价格和颜色不能为空"
          : null;
    });
    if (widget.noErr != null) {
      widget.noErr(_err == null ? true : false);
    }
    if (_err == null) {
      setState(() {
        _l.add({
          "code": widget.colorCtrl.text.trim(),
          "price": num.parse(widget.priceCtrl.text.trim()),
        });
        CusToast.toast(context, text: "已添加${_l.length}一种");
      });
    }
  }

  // 商品颜色和价格的输入框
  List<Widget> _inputs() {
    return <Widget>[
      Row(
        children: <Widget>[
          CusText("商品颜色", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: widget.colorCtrl,
              hintText: "商品颜色",
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
      Row(
        children: <Widget>[
          CusText("商品价格", t_yi, 30),
          Expanded(
            child: CusRectField(
              controller: widget.priceCtrl,
              hintText: "商品价格",
              autofocus: false,
              hideBorder: true,
            ),
          ),
        ],
      ),
    ];
  }
}
