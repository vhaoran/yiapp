import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/12 16:30
// usage ：选择商品的颜色和价格
// ------------------------------------------------------

typedef onColor = void Function(String color, int price);

class ProductColorShow extends StatefulWidget {
  final Product product;
  final onColor fnColor;

  ProductColorShow({
    this.product,
    this.fnColor,
    Key key,
  }) : super(key: key);

  @override
  _ProductColorShowState createState() => _ProductColorShowState();
}

class _ProductColorShowState extends State<ProductColorShow> {
  int _curSelect = -1; // 当前选择的哪一个
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: fif_primary,
      padding: EdgeInsets.all(Adapt.px(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "请选择颜色分类",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Wrap(children: <Widget>[..._show()]),
        ],
      ),
    );
  }

  /// 显示商品的颜色和价格
  List<Widget> _show() {
    List<ProductColor> l = widget.product.colors;
    return <Widget>[
      ...List.generate(
        l.length,
        (i) {
          _selected = _curSelect == i;
          var e = l[i];
          return Container(
            child: RaisedButton(
              onPressed: () {
                setState(() => _curSelect = i);
                if (widget.fnColor != null) {
                  widget.fnColor(e.code, e.price);
                }
              },
              color: _selected ? Colors.teal : Colors.white70,
              child: RichText(
                text: TextSpan(
                  children: <InlineSpan>[
                    // // 商品颜色和价格
                    TextSpan(
                      text: "${e.code}  ￥${e.price}",
                      style: TextStyle(
                        color: _selected ? Colors.white : Colors.black,
                        fontSize: Adapt.px(28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            margin: EdgeInsets.only(right: Adapt.px(15)),
          );
        },
      ),
    ];
  }
}
