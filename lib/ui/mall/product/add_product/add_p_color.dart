import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/8 18:28
// usage ：商品的价格和颜色
// ------------------------------------------------------

class ProductColorPrice extends StatefulWidget {
  final TextEditingController colorCtrl;
  final TextEditingController priceCtrl;
  final FnColorPrices fnColorPrice; // 已添加商品颜色和价格的回调

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
              CusRaisedButton(
                child: Text(
                  "添加",
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
                backgroundColor: t_gray,
                onPressed: _doAdd,
              ),
            ],
          ),
        ),
        Center(child: CusText("已添加颜色和价格表", t_yi, 30)),
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
              onlyNumber: true,
            ),
          ),
        ],
      ),
    ];
  }
}
