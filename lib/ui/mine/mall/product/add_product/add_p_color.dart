import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 18:28
// usage ：商品的价格和颜色
// ------------------------------------------------------

class ProductColorPrice extends StatefulWidget {
  final TextEditingController colorCtrl;
  final TextEditingController priceCtrl;
  final FnColorPrice fnColorPrice; // 已添加商品颜色和价格的回调

  ProductColorPrice({
    this.colorCtrl,
    this.priceCtrl,
    this.fnColorPrice,
    Key key,
  }) : super(key: key);

  @override
  _ProductColorPriceState createState() => _ProductColorPriceState();
}

class _ProductColorPriceState extends State<ProductColorPrice> {
  List<ProductColor> _l = []; // 商品的颜色和价格列表

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
                text: "添加",
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
        CusText("已添加颜色和价格表", t_yi, 30),
        _colorPrice(), // 显示已添加商品的颜色和价格
      ],
    );
  }

  // 将商品的颜色和价格添加到列表中
  void _doAdd() async {
    if (widget.colorCtrl.text.isNotEmpty && widget.priceCtrl.text.isNotEmpty) {
      await _l.add(
        ProductColor(
          code: widget.colorCtrl.text.trim(),
          price: num.parse(widget.priceCtrl.text.trim()),
        ),
      );
      widget.colorCtrl.clear();
      widget.priceCtrl.clear();
      if (widget.fnColorPrice != null) {
        widget.fnColorPrice(_l);
      }
      setState(() {});
    }
  }

  /// 显示已添加商品的颜色和价格
  Widget _colorPrice() {
    if (_l.isNotEmpty)
      return Column(
        children: <Widget>[
          CusText("已添加颜色和价格表", t_yi, 30),
          SizedBox(height: Adapt.px(10)),
          ...List.generate(
            _l.length,
            (i) {
              var e = _l[i];
              return Row(
                children: <Widget>[
                  CusText("第 ${i + 1} 种", t_gray, 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
                    child: CusText("颜色：${e.code}", t_gray, 28),
                  ),
                  CusText("价格：${e.price}", t_gray, 28),
                ],
              );
            },
          )
        ],
      );
    return SizedBox.shrink();
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
              hintText: "请输入商品颜色",
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
              hintText: "请输入商品价格",
              autofocus: false,
              hideBorder: true,
              formatter: true,
            ),
          ),
        ],
      ),
    ];
  }
}
